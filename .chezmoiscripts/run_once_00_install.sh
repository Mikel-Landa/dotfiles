#!/usr/bin/env bash

set -eo pipefail

is_wsl() { grep -qi microsoft /proc/version 2>/dev/null; }

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
if ! command -v mise >/dev/null 2>&1; then
    curl https://mise.run | sh
fi

# Make zsh the default shell — skip on WSL (chsh often unsupported / handled by /etc/wsl.conf)
# and skip if zsh is already the login shell.
if ! is_wsl && command -v zsh >/dev/null 2>&1 && [ "$(getent passwd "$USER" | cut -d: -f7)" != "$(command -v zsh)" ]; then
    chsh "$USER" -s "$(command -v zsh)" || echo "warning: chsh failed; set login shell manually" >&2
fi

#TMUX
if [[ ! -d ~/.tmux/plugins/tpm ]]; then
    mkdir -p ~/.tmux/plugins
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi