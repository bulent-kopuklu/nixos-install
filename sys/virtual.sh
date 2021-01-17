#! /bin/bash

drive=/dev/sda

sgdisk --zap-all $drive
parted $drive -- mklabel gpt
sgdisk --clear --new=1:0:0 --typecode=1:8300 --change-name=1:nixos $drive

sleep 1

mkfs.ext4 -L nixos /dev/disk/by-partlabel/nixos
mount LABEL=nixos /mnt

