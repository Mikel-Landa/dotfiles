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

# Rust prerequisites
if ! command -v rustc >/dev/null 2>&1 && ! command -v cargo >/dev/null 2>&1; then
curl https://sh.rustup.rs -sSf | sh -s -- -y
fi
. "$HOME/.cargo/env"
if ! command -v cargo-binstall >/dev/null 2>&1 && command -v cargo >/dev/null 2>&1; then
cargo install cargo-binstall
fi



# Metapac (sudo to ask password once)
paru -S --noconfirm metapac


# Mise
# curl https://mise.run | sh


# Make zsh the default shell (sudo to not ask for password again)
USERNAME=$USER
sudo chsh $USERNAME -s $(which zsh)

#TMUX
if [[ ! -d ~/.tmux/plugins/tpm ]]; then
mkdir -p ~/.tmux/plugins
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi