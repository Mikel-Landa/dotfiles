#!/bin/bash
# Better to know if anything fails. Can be removed if needed
set -e
GREEN="\n\033[0;32m"
RED='\n\033[0;31m'
NC="\033[0m"

function green() {
	echo -e "${GREEN}$1${NC}"
}

# Set up path for script
mkdir -p $HOME/.local/bin
export PATH="$HOME/.local/bin:$PATH"

green "Running Ubuntu bootstrap...."

# Update ubuntu
sudo apt-get update && sudo apt-get upgrade -y

# Swap escape and CAPS
dconf write "/org/gnome/desktop/input-sources/xkb-options" "[ 'caps:swapescape']"

# Set up basic dependencies
sudo apt install -y \
	curl \
	git \
	ripgrep \
	zip \
	autojump \
	pass \
	gpg \
	fzf \
	exa \
	bat \
	fd-find

[ -f $HOME/.local/bin/bat ] || ln -s /usr/bin/batcat $HOME/.local/bin/bat
[ -f $HOME/.local/bin/fd ] || ln -s $(which fdfind) ~/.local/bin/fd

# Neovim
green "Installing neovim..."
sudo apt-get install -y software-properties-common
sudo add-apt-repository -y ppa:neovim-ppa/unstable
sudo apt-get update
sudo apt-get install -y python3-dev python3-pip
sudo apt-get install -y neovim
sudo update-alternatives --install /usr/bin/vi vi /usr/bin/nvim 60
sudo update-alternatives --set vi /usr/bin/nvim
sudo update-alternatives --install /usr/bin/vim vim /usr/bin/nvim 60
sudo update-alternatives --set vim /usr/bin/nvim
sudo update-alternatives --install /usr/bin/editor editor /usr/bin/nvim 60
sudo update-alternatives --set editor /usr/bin/nvim
[ -d ~/.local/share/nvim/site/pack/packer/start/packer.nvim ] ||
	git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim

# Set up zsh
sudo apt install -y zsh
sudo chsh -s $(which zsh) $USER # sudo not needed, but allows to not reprompt for password

# Set up zap
ZAP_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/zap"
[[ -d "$ZAP_DIR" ]] ||
	zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh) --branch release-v1

# Install Node and npm

green "Install Node and npm..."

export PROFILE="/dev/null" # Dont append nvm sources to rc
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
nvm install 16
nvm install 18
sudo apt-get install -y npm
nvm use 18

# Install lunarvim

green "Installing lunarvim..."

sudo apt install -y \
	cargo \
	make \
	python3

LV_BRANCH='release-1.3/neovim-0.9'
bash <(curl -s https://raw.githubusercontent.com/LunarVim/LunarVim/${LV_BRANCH}/utils/installer/install.sh) --yes

# Install nerd fonts"
green "Installing Nerd Fonts..."
green "[-] Download fonts [-]"
green "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/Cousine.zip"
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/Cousine.zip
unzip -o Cousine.zip -d ~/.fonts
rm -rf Cousine.zip
fc-cache -fv

# Install tmux
green "Installing tmux..."
sudo apt install -y tmux
[ -d ~/.tmux/plugins/tpm ] || git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Install starship
green "Installing starship..."
curl -sS https://starship.rs/install.sh | sudo sh -s -- -y

# Install alacritty

green "Installing allacritty..."
sudo add-apt-repository ppa:aslatter/ppa -y
sudo apt install -y alacritty

## GENERAL CONFIG

mkdir -p $HOME/local/share/zsh/completions
