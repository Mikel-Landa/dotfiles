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
if ! command -v rustc >/dev/null 2>&1 && command -v cargo >/dev/null 2>&1; then
curl https://sh.rustup.rs -sSf | sh -s -- -y
fi
. "$HOME/.cargo/env"
if ! command -v cargo-binstall >/dev/null 2>&1 && command -v cargo >/dev/null 2>&1; then
cargo install cargo-binstall
fi


# Metapac (sudo to ask password once)
paru -S metapac


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