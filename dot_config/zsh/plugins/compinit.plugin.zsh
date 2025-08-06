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

# If the user wants it, load from all found directories
compinit -u -C -d "${ZSH_COMPDUMP}"

# Append zcompdump metadata if missing
if (( $zcompdump_refresh )); then
  echo "\n$zcompdump_revision\n$zcompdump_fpath" >>! "$ZSH_COMPDUMP"
fi

# Do once a day
_ZCOMP=${ZDOTDIR:-$HOME}/.zcompdump
today=$(date --date '00:00 today' +%s)
if [[ ! -e $_ZCOMP || $today -gt $(stat --format %Y $_ZCOMP) ]];
then
  touch ${_ZCOMP}
  xzcompilefpath
  xzcompilehomedir
fi

unset zcompdump_revision zcompdump_fpath zcompdump_refresh _ZCOMP