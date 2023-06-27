#!/bin/sh
# HISTFILE="$XDG_DATA_HOME"/zsh/history
HISTSIZE=1000000
SAVEHIST=1000000
export EDITOR="nvim"
export TERMINAL="alacritty"
export BROWSER="firefoz"
export MANPAGER='nvim +Man!'
export MANWIDTH=999
export XDG_CURRENT_DESKTOP="Wayland"

[ -f $HOME/.variables ] && . $HOME/.variables
