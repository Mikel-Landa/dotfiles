#!/usr/bin/env bash

set -e
set -o pipefail

# Prerequisites
sudo apt-get update
sudo apt-get install -y \
curl \
git \
gcc \
zsh \
zsh-autosuggestions \
zsh-syntax-highlighting \
fzf \
eza \
ripgrep \
ranger \
zip \
gpg

# Rust packages
curl https://sh.rustup.rs -sSf | sh -s -- -y
. "$HOME/.cargo/env"
cargo install cargo-binstall
cargo binstall -y \
bat \
starship \
zoxide \
zellij

# Mise
curl https://mise.run | sh

# Chezmoi
~/.local/bin/mise use -g \
chezmoi \
kubectl

# Make zsh the default shell (sudo to not ask for password again)
USERNAME=$USER
sudo chsh $USERNAME -s $(which zsh)

# Apply Config
chezmoi apply --force
