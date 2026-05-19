#!/usr/bin/env zsh
# Phase 60 — precompile zsh files to .zwc for faster sourcing.
# Idempotent: mtime-gated per file (no-op when .zwc is fresh).
# Runs every `chezmoi apply`.
set -eu
emulate -L zsh

_compile() {
    local f=$1
    [[ -f $f ]] || return 0
    [[ -s ${f}.zwc && ! ${f} -nt ${f}.zwc ]] && return 0
    zcompile -- "$f" 2>/dev/null || return 0
}

# Top-level dotfiles.
for f in \
    $HOME/.profile \
    $HOME/.zshenv \
    $HOME/.zshrc \
    $HOME/.zprofile \
    $HOME/.p10k.zsh
do
    _compile $f
done

# Plugin + autoload dirs under $XDG_CONFIG_HOME/zsh.
for d in \
    ${XDG_CONFIG_HOME:-$HOME/.config}/zsh/plugins \
    ${XDG_CONFIG_HOME:-$HOME/.config}/zsh/autoload
do
    [[ -d $d ]] || continue
    for f in $d/*(.N); do
        _compile $f
    done
done
