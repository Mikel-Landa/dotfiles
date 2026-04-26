#!/usr/bin/env zsh

# Load all the functions that we have in autoload

# required for non interactive use
setopt extendedglob

fpath=(
    $HOME/.config/zsh/autoload
    $fpath
)

autoloading=(
    ${fpath[1]}/^**.zwc(:t)
);

if [[ -o interactive ]]; then

    autoloading=(
        $autoloading
        add-zsh-hook
        is-at-least
        promptinit
        compinit
    )
fi

autoload -Uz $autoloading

# vim: ft=zsh