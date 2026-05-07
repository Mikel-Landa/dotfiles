#!/usr/bin/env zsh

# Load all the functions that we have in autoload

# required for non interactive use
setopt extendedglob

fpath=(
    $HOME/.config/zsh/autoload
    $fpath
)

# Cache the recursive glob result; invalidate on autoload dir mtime change.
zmodload -F zsh/stat b:zstat 2>/dev/null
local _autoload_cache="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/autoload-list.zsh"
local -a _autoload_dir_mt _autoload_cache_mt
zstat -A _autoload_dir_mt   +mtime ${fpath[1]} 2>/dev/null
zstat -A _autoload_cache_mt +mtime $_autoload_cache 2>/dev/null

if (( ${_autoload_cache_mt[1]:-0} >= ${_autoload_dir_mt[1]:-1} )) && [[ -s $_autoload_cache ]]; then
    source $_autoload_cache
else
    autoloading=( ${fpath[1]}/^**.zwc(:t) )
    [[ -d ${_autoload_cache:h} ]] || mkdir -p ${_autoload_cache:h}
    print -r -- "autoloading=( ${(j: :)${(qq)autoloading}} )" >| $_autoload_cache
fi
unset _autoload_cache _autoload_dir_mt _autoload_cache_mt

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
