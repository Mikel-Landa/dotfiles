autoload -Uz _evalcache
# Evals
_evalcache zoxide init zsh --cmd j
_evalcache mise activate zsh
_evalcache fzf --zsh
_evalcache kubectl completion zsh
_evalcache helm completion zsh

# Tab: accept suggestion if active, else open completion menu (must be last — compinit resets ^I)
_tab_or_autosuggest() {
  if [[ -n $POSTDISPLAY ]]; then
    zle autosuggest-accept
  else
    zle menu-complete
  fi
}
zle -N _tab_or_autosuggest
bindkey -M viins '^I' _tab_or_autosuggest
bindkey -M emacs '^I' _tab_or_autosuggest