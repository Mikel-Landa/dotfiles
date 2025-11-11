#!/usr/bin/env bash

set -eo pipefail

if ! command -v pacman >/dev/null 2>&1; then
  #Ignoring arch packages on a non-arch-based distro
  exit 0
fi

# Install paru if not there
if ! command -v paru >/dev/null 2>&1; then
    mkdir -p /tmp/paru
    cd /tmp/paru
    sudo pacman -S --needed base-devel
    git clone https://aur.archlinux.org/paru.git
    cd paru
    makepkg -si
    cd -
fi