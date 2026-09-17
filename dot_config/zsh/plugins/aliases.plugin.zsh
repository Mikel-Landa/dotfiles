#!/usr/bin/env zsh

# ls
alias la=tree
alias cat=bat
# Eza
alias l="eza -l --icons --git -a"
alias lt="eza --tree --level=2 --long --icons --git"
alias ltree="eza --tree --level=2  --icons --git"

# GIT
alias gad="git add --all"
alias gcm="git commit -m"
alias gc="git commit"
alias gp="git push"
alias gpl="git pull origin"
alias gco="git checkout"
alias gsp="git stash pop"
alias gs="git status"
alias glog="git log --graph --topo-order --pretty='%w(100,0,6)%C(yellow)%h%C(bold)%C(black)%d %C(cyan)%ar %C(green)%an%n%C(bold)%C(white)%s %N' --abbrev-commit"
alias gm="git merge"
alias gb="git branch"
alias gr="git rebase"
alias gf="git fetch"
gda(){
	GIT_ROOT=$(git rev-parse --show-toplevel) 
	git restore $GIT_ROOT && git clean -fd $GIT_ROOT
}


# vim
(( $+commands[vim] )) && alias vi='vim'
alias v="nvim"


alias cl='clear'

# Kubernetes
alias k="kubectl"
alias ka="kubectl apply -f"
alias kg="kubectl get"
alias kd="kubectl describe"
alias kdel="kubectl delete"
alias kl="kubectl logs -f"
alias kgpo="kubectl get pod"
alias kgd="kubectl get deployments"
alias kc="kubectx"
alias kns="kubens"
alias ke="kubectl exec -it"
alias kcns='kubectl config set-context --current --namespace'

#TMUX
alias t='tmux'

#TERRAFORM
alias tf='terraform'

#DOCKER
alias dc='docker compose'

# navigation
cx() { cd "$@" && l; }
fcd() {
    local dir
    dir=$(FZF_DEFAULT_COMMAND="$FZF_ALT_C_COMMAND" fzf --preview 'eza --tree --level=2 --color=always -- {}') || return
    [[ -n $dir ]] && cd -- "$dir" && l
}
f() {
    local file
    file=$(fzf --preview 'bat --paging=never --color=always --line-range=:300 -- {}') || return
    [[ -n $file ]] && print -rn -- "$file" | uclip
}
fv() {
    local file
    file=$(fzf --preview 'bat --paging=never --color=always --line-range=:300 -- {}') || return
    [[ -n $file ]] && nvim -- "$file"
}

# vim: filetype=zsh syntax=zsh

# --- Socket Firewall (sfw) install-time scanning. Interactive shells only;
# --- CI coverage comes from socketdev/action. Guarded so it is a no-op if sfw is not installed.
if (( $+commands[sfw] )); then
  alias pnpm='sfw pnpm'
  alias npm='sfw npm'
  alias cargo='sfw cargo'
  alias uv='sfw uv'
  alias pip='sfw pip'
fi
