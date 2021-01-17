#! /run/current-system/sw/bin/bash

sys=$1

echo "starting " $sys "..."

case $sys in
    thinkpad-x1 | i5-desktop)
        source "sys/luks-btrfs.sh"
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

nixos-generate-config --root /mnt

git clone https://github.com/bulent-kopuklu/nixos-config.git /mnt/etc/nixos-config
ln -s /mnt/etc/nixos/nixos-config/sys/$sys /mnt/etc/nixos/nixos-config/sys/current



