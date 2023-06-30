#!/bin/sh

COMPLETIONS_DIR="$HOME/.config/zsh/completions/"

source $COMPLETIONS_DIR/kubectl.zsh

source /usr/share/doc/fzf/examples/key-bindings.zsh
source /usr/share/doc/fzf/examples/completion.zsh

# ASDF
# append completions to fpath
fpath=(${ASDF_DIR}/completions $fpath)
# initialise completions with ZSH's compinit
