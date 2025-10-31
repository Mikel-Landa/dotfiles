#!/usr/bin/env bash

set -euo pipefail

# Prerequisites
sudo apt-get update
sudo apt-get install -y \
curl \
wget \
git \
gcc \
zsh \
zsh-autosuggestions \
zsh-syntax-highlighting \
eza \
ripgrep \
ranger \
zip \
gpg \
pkg-config \
libssl-dev \
build-essential \
lazygit \
sshuttle

# Rust packages
curl https://sh.rustup.rs -sSf | sh -s -- -y
. "$HOME/.cargo/env"
cargo install cargo-binstall
cargo binstall -y \
bat \
zoxide \
zellij \
nu \
sheldon \
tree-sitter-cli \
fd-find \
tmux

# Mise
curl https://mise.run | sh

# Chezmoi
~/.local/bin/mise use -g \
chezmoi \
kubectl \
go

# LazyGit
go install github.com/jesseduffield/lazygit@latest

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

# Make zsh the default shell (sudo to not ask for password again)
if [[ ! -d $HOME/.local/share/chezmoi ]]; then
USERNAME=$USER
sudo chsh $USERNAME -s $(which zsh)

# Apply Config
GITHUB_USERNAME="Mikel-Landa"
chezmoi init --apply --verbose https://github.com/$GITHUB_USERNAME/dotfiles.git

# Populate git email
if [[ ! -n $EMAIL ]]; then
echo Specify work email:
read EMAIL
fi

mkdir -p ~/.config/git
echo -e "[user]\n\temail= $EMAIL" > ~/.config/git/config
fi

#TMUX
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm