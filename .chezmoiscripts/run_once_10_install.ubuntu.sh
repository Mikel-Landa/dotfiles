#!/usr/bin/env bash

set -euo pipefail

if [ "$(grep '^ID=' /etc/os-release | cut -d= -f2)" = "ubuntu" ]; then
    echo "Ubuntu detected"
else
    echo "Not Ubuntu"
fi



# Fzf (ubuntu package is very out of date)
curl -s https://api.github.com/repos/junegunn/fzf/releases/latest \
| grep 'browser_download_url.*fzf-0.64.0-linux_amd64.tar.gz' \
| cut -d : -f 2,3 \
| tr -d \" \
| wget -qi -

tar -xzf fzf-0.64.0-linux_amd64.tar.gz
sudo install fzf /usr/bin
rm fzf-0.64.0-linux_amd64.tar.gz fzf
INIT_DIR=${ZDOTDIR:-$HOME/.config/zsh}/init
mkdir -p $INIT_DIR
fzf --zsh > $INIT_DIR/fzf.zsh