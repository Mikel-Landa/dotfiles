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
fcd() { cd "$(find . -type d -not -path '*/.*' | fzf)" && l; }
_clipcopy() {
    if (( $+commands[wl-copy] )); then wl-copy
    elif (( $+commands[xclip] )); then xclip -selection clipboard
    elif (( $+commands[xsel] )); then xsel --clipboard --input
    elif (( $+commands[pbcopy] )); then pbcopy
    else cat >/dev/null
    fi
}
f() { find . -type f -not -path '*/.*' | fzf | _clipcopy }
fv() { nvim "$(find . -type f -not -path '*/.*' | fzf)" }

# vim: filetype=zsh syntax=zsh

