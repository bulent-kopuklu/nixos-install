#! /run/current-system/sw/bin/bash

drive=/dev/sda

sgdisk --zap-all $drive

parted $drive -- mklabel msdos
parted $drive -- mkpart primary 1MiB 100%

sleep 1

mkfs.ext4 -L nixos /dev/sda1
mount /dev/sda1 /mnt

