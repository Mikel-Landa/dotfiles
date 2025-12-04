#!/usr/bin/env bash

set -eo pipefail

# Rust prerequisites
if ! command -v rustc >/dev/null 2>&1 && ! command -v cargo >/dev/null 2>&1; then
curl https://sh.rustup.rs -sSf | sh -s -- -y
fi
. "$HOME/.cargo/env"
if ! command -v cargo-binstall >/dev/null 2>&1; then
cargo install cargo-binstall
fi

if ! command -v metapac >/dev/null 2>&1; then
    mkdir -p ~/personal ~/bin
    git clone git@github.com:Mikel-Landa/metapac.git ~/personal/metapac
    cd ~/personal/metapac
    cargo build --release
    mv target/release/metapac ~/bin
fi

#Mise
curl https://mise.run | sh

# Make zsh the default shell
USERNAME=$USER
chsh $USERNAME -s $(which zsh)

#TMUX
if [[ ! -d ~/.tmux/plugins/tpm ]]; then
mkdir -p ~/.tmux/plugins
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi