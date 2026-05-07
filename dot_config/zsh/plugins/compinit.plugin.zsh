#!/usr/bin/env zsh

# Native zsh modules — no subprocess forks.
zmodload -F zsh/stat b:zstat 2>/dev/null

# Load all stock functions (from $fpath files) called below.
autoload -U compaudit compinit

# Figure out the SHORT hostname
SHORT_HOST=${HOST/.*/}

# Save the location of the current completion dump file (XDG cache).
ZSH_COMPDUMP="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-${SHORT_HOST}-${ZSH_VERSION}"
[[ -d ${ZSH_COMPDUMP:h} ]] || mkdir -p ${ZSH_COMPDUMP:h}

# Construct zcompdump metadata, we will rebuild the Zsh compdump if either
# this file changes or the fpath changes. Use mtime instead of sha1sum to
# avoid a subprocess fork per shell startup.
local -a _zcompdump_self_mt
zstat -A _zcompdump_self_mt +mtime $0:A 2>/dev/null
zcompdump_revision="#revision: ${_zcompdump_self_mt[1]:-0}"
zcompdump_fpath="#fpath: $fpath"
unset _zcompdump_self_mt

# Read dump file once into an array; native zsh array match replaces grep -Fx.
local -a _zcompdump_lines
[[ -r $ZSH_COMPDUMP ]] && _zcompdump_lines=( ${(f)"$(<$ZSH_COMPDUMP)"} )
if [[ ${_zcompdump_lines[(r)$zcompdump_revision]} != $zcompdump_revision \
   || ${_zcompdump_lines[(r)$zcompdump_fpath]}    != $zcompdump_fpath    ]]; then
  command rm -f "$ZSH_COMPDUMP"
  zcompdump_refresh=1
fi
unset _zcompdump_lines

# Case-insensitive completion (full bidirectional)
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric
setopt NO_CASE_GLOB

# If the user wants it, load from all found directories
compinit -C -d "${ZSH_COMPDUMP}"

# Append zcompdump metadata if missing
if (( $zcompdump_refresh )); then
  print -- "\n$zcompdump_revision\n$zcompdump_fpath" >>! "$ZSH_COMPDUMP"
fi

# Always run; xzcompile/xzcompiledir are mtime-gated per file (cheap no-ops
# when .zwc is fresh). Previous daily gate masked stale .zwc after edits.
xzcompilefpath
xzcompilehomedir

unset zcompdump_revision zcompdump_fpath zcompdump_refresh
