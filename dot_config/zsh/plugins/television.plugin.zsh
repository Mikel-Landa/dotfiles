# television (tv) `**<TAB>` trigger — fzf-style on-demand picker.
#
# Typing `**` immediately before <TAB> opens tv with the channel guessed from
# the leading command (per `[shell_integration.channel_triggers]` in
# ~/.config/television/config.toml). Examples:
#     kill **<TAB>      -> procs channel
#     ssh **<TAB>       -> ssh-hosts channel
#     git checkout **<TAB> -> git-branch channel
#     vim **<TAB>       -> files channel (fallback)
#
# Multi-select: in tv, <space> toggles selection (configured in tv's
# config.toml). On confirm, all selected entries are inserted into the command
# line, shell-quoted, joined by a separator. Default separator is a single
# space; override per command via the TV_STAR_JOIN assoc array, e.g.
#     typeset -gA TV_STAR_JOIN
#     TV_STAR_JOIN[ssh]=','       # ssh user@a,b,c style
#
# Coexists with tv's built-in `^T` smart-autocomplete and `^R` history (set
# up by `tv init zsh`). When `**` is not present, falls back to the previous
# TAB widget so normal completion is unaffected.

(( $+commands[tv] )) || return 0

typeset -gA TV_STAR_JOIN

_tv_star_complete() {
    emulate -L zsh
    setopt local_options no_aliases noshwordsplit noksh_arrays

    if [[ $LBUFFER != *'**' ]]; then
        zle ${_tv_star_fallback:-expand-or-complete}
        return
    fi

    local prefix=${LBUFFER%\*\*}
    local stripped=${prefix%% }
    [[ -z $stripped ]] && stripped="$prefix"

    # First word of the command line drives the per-tool separator override.
    local cmd=${${stripped## }%% *}
    local sep=${TV_STAR_JOIN[$cmd]:- }

    zle -I

    local raw
    raw=$(tv --autocomplete-prompt "$stripped" \
              --inline \
              --no-status-bar \
              < /dev/tty)

    if [[ -n $raw ]]; then
        local -a items
        items=("${(@f)raw}")
        local joined="" item first=1
        for item in $items; do
            [[ -z $item ]] && continue
            if (( first )); then
                joined="${(q-)item}"
                first=0
            else
                joined+="${sep}${(q-)item}"
            fi
        done
        LBUFFER="${prefix}${joined}"
    fi
    zle reset-prompt
}
zle -N _tv_star_complete

# Capture whatever TAB was bound to first so fall-through is preserved
# (e.g. menu-complete, or another plugin's widget).
_tv_star_fallback=$(bindkey -M viins '^I' 2>/dev/null | awk '{print $2}')
[[ -z $_tv_star_fallback || $_tv_star_fallback == undefined-key ]] && _tv_star_fallback=expand-or-complete

bindkey -M viins '^I' _tv_star_complete
bindkey -M emacs '^I' _tv_star_complete
