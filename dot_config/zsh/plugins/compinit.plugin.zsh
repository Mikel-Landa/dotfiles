#!/usr/bin/env zsh

# Load all stock functions (from $fpath files) called below.
autoload -U compaudit compinit
# autoload -Uz xzcompilefpath

# Figure out the SHORT hostname
SHORT_HOST=${HOST/.*/}

# Save the location of the current completion dump file.
ZSH_COMPDUMP="${ZDOTDIR:-${HOME}}/.zcompdump-${SHORT_HOST}-${ZSH_VERSION}"

# Construct zcompdump metadata, we will rebuild the Zsh compdump if either
# this file changes or the fpath changes.
zcompdump_revision="#revision: $(sha1sum $0:A)"
zcompdump_fpath="#fpath: $fpath"

# Delete the zcompdump file if zcompdump metadata changed
if ! command grep -q -Fx "$zcompdump_revision" "$ZSH_COMPDUMP" 2>/dev/null \
   || ! command grep -q -Fx "$zcompdump_fpath" "$ZSH_COMPDUMP" 2>/dev/null; then
  command rm -f "$ZSH_COMPDUMP"
  zcompdump_refresh=1
fi

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
  echo "\n$zcompdump_revision\n$zcompdump_fpath" >>! "$ZSH_COMPDUMP"
fi

# Recompile autoload + home dotfiles at most once per day
if [[ ! -e $ZSH_COMPDUMP || $(date +%s) -gt $(( $(stat -c %Y "$ZSH_COMPDUMP") + 86400 )) ]]; then
  xzcompilefpath
  xzcompilehomedir
fi

unset zcompdump_revision zcompdump_fpath zcompdump_refresh