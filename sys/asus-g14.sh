#! /usr/bin/env bash

: ${DRIVER:=/dev/nvme0n1}
: ${SWAP_FILE_SIZE:=19327352832}

source $(pwd)/sys/luks-btrfs.sh

mkpart $DRIVER
mkenc
mkfs
mkswapfile $SWAP_FILE_SIZE

sudo nix-channel --add https://github.com/NixOS/nixos-hardware/archive/master.tar.gz nixos-hardware
sudo nix-channel --update

