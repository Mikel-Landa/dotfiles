#!/usr/bin/env bash

set -euo pipefail

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

# Rust prerequisites
curl https://sh.rustup.rs -sSf | sh -s -- -y
. "$HOME/.cargo/env"
cargo install cargo-binstall

# Metapac (sudo to ask password once)
sudo paru -S metapac


# Mise
curl https://mise.run | sh


# Make zsh the default shell (sudo to not ask for password again)
if [[ ! -d $HOME/.local/share/chezmoi ]]; then
USERNAME=$USER
sudo chsh $USERNAME -s $(which zsh)

#TMUX
mkdir -p ~/.tmux/plugins
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Populate git email
if [[ ! -n $EMAIL ]]; then
echo Specify work email:
read EMAIL
fi

mkdir -p ~/.config/git
echo -e "[user]\n\temail= $EMAIL" > ~/.config/git/config
fi