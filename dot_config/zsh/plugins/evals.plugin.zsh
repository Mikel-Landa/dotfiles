autoload -Uz _evalcache

# Spec lives in ~/.config/shell/evals.sh so zsh and bash share the list.
# Use _evalcache here for caching; bash uses plain eval in dot_bashrc.
if [[ -r "$HOME/.config/shell/evals.sh" ]]; then
    source "$HOME/.config/shell/evals.sh"
    shell_evals_for zsh | while IFS= read -r _eval_cmd; do
        _eval_tool=${_eval_cmd%% *}
        if (( $+commands[$_eval_tool] )); then
            _evalcache ${(z)_eval_cmd}
        fi
    done
    unset _eval_cmd _eval_tool
fi
