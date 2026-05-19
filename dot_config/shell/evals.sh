# Shared tool-init spec. Single source of truth for shell-init evals.
# Consumers call shell_evals_for <shell> and decide their caching strategy
# (zsh uses _evalcache; bash uses plain eval).

shell_evals_for() {
    _s=$1
    printf '%s\n' \
        "zoxide init $_s" \
        "mise activate $_s" \
        "fzf --$_s" \
        "kubectl completion $_s" \
        "helm completion $_s"
    unset _s
}
