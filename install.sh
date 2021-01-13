
#! /bin/bash

DRIVE=/dev/sda

sgdisk --zap-all $DRIVE
parted /dev/sda -- mklabel gpt
sgdisk --clear --new=1:0:+512MiB --typecode=1:ef00 --change-name=1:BOOT --new=2:0:0 --typecode=2:8309 --change-name=2:cryptsystem $DRIVE

sleep 1


mkfs.fat -F32 -n BOOT /dev/disk/by-partlabel/BOOT

cryptsetup luksFormat --align-payload=8192 -s 256 -c aes-xts-plain64 /dev/disk/by-partlabel/cryptsystem
cryptsetup open /dev/disk/by-partlabel/cryptsystem system

mkfs.btrfs --force --label system /dev/mapper/system

mount -t btrfs LABEL=system /mnt

btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@log
btrfs subvolume create /mnt/@docker
btrfs subvolume create /mnt/@nix
btrfs subvolume create /mnt/@snapshots
btrfs subvolume create /mnt/@srv
btrfs subvolume create /mnt/@machine

umount -R /mnt

o_btrfs=defaults,ssd,noatime

#,compress=zstd:1

mount -t btrfs -o subvol=@,$o_btrfs LABEL=system /mnt

mkdir -p /mnt/home
mount -t btrfs -o subvol=@home,$o_btrfs LABEL=system /mnt/home

mkdir -p /mnt/srv
mount -t btrfs -o subvol=@srv,$o_btrfs LABEL=system /mnt/srv

mkdir -p /mnt/nix
mount -t btrfs -o subvol=@nix,$o_btrfs LABEL=system /mnt/nix

mkdir -p /mnt/var/log
mount -t btrfs -o subvol=@log,$o_btrfs LABEL=system /mnt/var/log

mkdir -p /mnt/var/lib/docker
mount -t btrfs -o subvol=@docker,$o_btrfs LABEL=system /mnt/var/lib/docker

mkdir -p /mnt/var/lib/machine
mount -t btrfs -o subvol=@machine,$o_btrfs LABEL=system /mnt/var/lib/machine

mkdir -p /mnt/.snapshots
mount -t btrfs -o subvol=@snapshots,$o_btrfs LABEL=system /mnt/.snapshots

mkdir -p /mnt/boot
mount LABEL=BOOT /mnt/boot

SWAPFILE=/mnt/var/.swapfile

truncate -s 0 $SWAPFILE
chattr +C $SWAPFILE
btrfs property set $SWAPFILE compression none
chmod 0600 $SWAPFILE
fallocate -l 18G $SWAPFILE
mkswap $SWAPFILE
swapon $SWAPFILE

free

nixos-generate-config --root /mnt


