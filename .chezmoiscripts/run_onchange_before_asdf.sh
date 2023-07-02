#!/bin/bash

set -e

# Load
[ $(type -t asdf) ] && . "$HOME/.asdf/asdf.sh"

GREEN="\n\033[0;32m"
RED='\n\033[0;31m'
NC="\033[0m"

function green() {
	echo -e "${GREEN}$1${NC}"
}

function asdf_install() {
	asdf plugin-add $@ && status_code=$? || status_code=$?
	if [ $status_code -eq 0 ] || [ $status_code -eq 2 ]; then
		green "$1 is installed"
	fi
}
# Install asdf

green "Installing asdf..."
[ -d ~/.asdf ] || git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.12.0

## HASHICORP
asdf_install terraform https://github.com/asdf-community/asdf-hashicorp.git
asdf install terraform latest
asdf global terraform latest

asdf_install packer https://github.com/asdf-community/asdf-hashicorp.git
asdf install packer latest
asdf global packer latest

## Kubectl
asdf_install kubectl https://github.com/asdf-community/asdf-kubectl.git
asdf install kubectl latest
asdf global kubectl latest

kubectl completion zsh >$HOME/local/share/zsh/completions/_kubectl
