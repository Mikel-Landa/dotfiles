# shellcheck shell=sh
# Shared by bash and zsh. fd respects .gitignore; include useful dotfiles.
export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git --exclude node_modules --exclude target --exclude .venv'
export FZF_CTRL_T_COMMAND='fd --type f --type d --hidden --exclude .git --exclude node_modules --exclude target --exclude .venv'
export FZF_ALT_C_COMMAND='fd --type d --hidden --exclude .git --exclude node_modules --exclude target --exclude .venv'
export FZF_CTRL_T_OPTS="--preview 'if [ -d {} ]; then eza --tree --level=2 --color=always -- {}; else bat --paging=never --color=always --line-range=:300 -- {}; fi'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --level=2 --color=always -- {}'"
