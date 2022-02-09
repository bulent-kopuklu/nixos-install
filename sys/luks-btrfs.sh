
ROOT_LABEL=cryptsystem
MAPPER_LABEL=system
SWAP_FILE_PATH=/mnt/var/.swapfile


function mkpart() {
  local drive=$1

  sgdisk --zap-all $drive
  parted $drive -- mklabel gpt
  sgdisk --clear --new=1:0:+2GiB --typecode=1:ef00 --change-name=1:BOOT --new=2:0:0 --typecode=2:8309 --change-name=2:$ROOT_LABEL $drive

  sleep 1
}

function mkenc() {
  cryptsetup luksFormat --align-payload=8192 -s 256 -c aes-xts-plain64 /dev/disk/by-partlabel/$ROOT_LABEL
  cryptsetup open /dev/disk/by-partlabel/$ROOT_LABEL $MAPPER_LABEL
}

function mkfs() {
  mkfs.fat -F32 -n BOOT /dev/disk/by-partlabel/BOOT
  mkfs.btrfs --force --label $MAPPER_LABEL /dev/mapper/$MAPPER_LABEL

  mount -t btrfs LABEL=$MAPPER_LABEL /mnt

  btrfs subvolume create /mnt/@
  btrfs subvolume create /mnt/@home
  btrfs subvolume create /mnt/@var
  btrfs subvolume create /mnt/@nix
  btrfs subvolume create /mnt/@snapshots
  

  umount -R /mnt

  o_btrfs=defaults,ssd,noatime

  #,compress=zstd:1

  mount -t btrfs -o subvol=@,$o_btrfs LABEL=$MAPPER_LABEL /mnt

  mkdir -p /mnt/home
  mount -t btrfs -o subvol=@home,$o_btrfs LABEL=$MAPPER_LABEL /mnt/home

  mkdir -p /mnt/var
  mount -t btrfs -o subvol=@var,$o_btrfs LABEL=$MAPPER_LABEL /mnt/var

  mkdir -p /mnt/nix
  mount -t btrfs -o subvol=@nix,$o_btrfs LABEL=$MAPPER_LABEL /mnt/nix

  mkdir -p /mnt/.snapshots
  mount -t btrfs -o subvol=@snapshots,$o_btrfs LABEL=$MAPPER_LABEL /mnt/.snapshots

  mkdir -p /mnt/boot
  mount LABEL=BOOT /mnt/boot
}

function mkswapfile() {
  local swapsize=$1
  truncate -s 0 $SWAP_FILE_PATH
  chattr +C $SWAP_FILE_PATH
  btrfs property set $SWAP_FILE_PATH compression none
  chmod 0600 $SWAP_FILE_PATH
  fallocate -l $swapsize $SWAP_FILE_PATH
  mkswap $SWAP_FILE_PATH
  swapon $SWAP_FILE_PATH
}

