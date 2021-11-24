#!  /usr/bin/env bash

sys=$1

echo "starting " $sys "..."

case $sys in
    thinkpadx1-4th | i5-desktoppc)
        source "sys/luks-btrfs.sh"
        ;;
    asus-g14)
        source "sys/asus-g14.sh"
        ;;
    rp3-homegw)
        echo "sys/raspberry.sh"
        ;;
    virtualbox)
        source "sys/virtual.sh"
        ;;
    *)
        echo "unknow"
        exit
        ;;
esac

#nixos-generate-config --root /mnt

git clone https://github.com/bulent-kopuklu/nixos-config.git /mnt/etc/nixos/config
ln -s /mnt/etc/nixos/config/sys/$sys /mnt/etc/nixos/config/sys/current
ln -s /mnt/etc/configuration.nix /mnt/etc/nixos/config/configuration.nix



