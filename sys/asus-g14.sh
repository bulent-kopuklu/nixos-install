#! /usr/bin/env bash

: ${DRIVER:=/dev/nvme0n1}
: ${SWAP_FILE_SIZE:=19327352832}

source ./luks-btrfs.sh

mkpart $DIRIVER
mkenc
mkfs
mkswapfile $SWAP_FILE_SIZE

sudo nix-channel --add https://github.com/NixOS/nixos-hardware/archive/master.tar.gz nixos-hardware
sudo nix-channel --update

