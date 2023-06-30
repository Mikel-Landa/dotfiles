#!/bin/bash

GREEN="\n\033[0;32m"
RED='\n\033[0;31m'
NC="\033[0m"

function green() {
	echo -e "${GREEN}$1${NC}"
}
# Install asdf

green "Installing asdf..."
[ -d ~/.asdf ] || git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.12.0


## HASHICORP
asdf plugin-add terraform https://github.com/asdf-community/asdf-hashicorp.git || true
asdf plugin-add packer https://github.com/asdf-community/asdf-hashicorp.git || true
