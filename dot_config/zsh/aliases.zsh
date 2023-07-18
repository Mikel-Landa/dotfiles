# NPM alias nrs="npm run serve"

# DJANGO
alias pm="python manage.py"
alias pmf="python manage.py flush --noinput"
alias pmfd="python manage.py fake_data"
alias pmmk="python manage.py makemigrations"
alias pmm="python manage.py migrate"
alias pmr="python manage.py runserver"
alias wk="workon"
#Django Docker
pips() {
    package_names=("${@:1:${#}-1}")
    requirements_file="${@: -1}"
    if [[ -z $requirements_file ]]
    then
        requirements_file='base'
    fi
    for package_name in "${package_names[@]}";do
    	pip install $package_name && pip freeze | grep -i $package_name >> ./requirements/$requirements_file.txt
    done
}
# MISC
alias ll="ls -lah"
alias lt="ls -laht"

#GIT 
alias gco="git checkout"
alias gpt="git push origin --tags"
alias gcm="git commit -m"
alias gcam="git commit -am"
alias gad="git add -A"
alias gp="git push"
alias gpl="git pull"
alias gmdmm="git checkout dev && git merge master && git checkout master && git merge dev"
alias noci="skip_ci"
# TMUX

alias t="tmux"
alias ta="t a -t"
alias tls="t ls"
alias tn="t new -t"
alias ts="t new -s"
alias mux='pgrep -vx tmux > /dev/null && \
		tmux new -d -s delete-me && \
		tmux run-shell ~/.tmux/plugins/tmux-resurrect/scripts/restore.sh && \
		tmux kill-session -t delete-me && \
		tmux attach || tmux attach'




# system

alias s='systemctl'

# kubernetes
alias k='kubectl'
alias kctx='kubectx'
alias kns='kubens'

#useful base64 encoding

function dekode() {
    out=$(echo $1 | base64 -d)
    if command -v clip.exe &> /dev/null
    then
        echo $out | tr '\n' ' ' |  clip.exe
    else
        echo $out | tr '\n' ' ' | xclip
    fi
    echo $out
}
function enkode() {
    out=$(echo $1 | base64 -w0)
    if command -v clip.exe &> /dev/null
    then
        echo $out | tr '\n' ' ' |  clip.exe
    else
        echo $out | tr '\n' ' ' | xclip
    fi
    echo $out
}

# terraform
alias tf="terraform"
alias grunt="terragrunt"

# bat
alias cat="bat -pp --theme \"Visual Studio Dark+\"" 
alias catt="bat --theme \"Visual Studio Dark+\"" 

# editor
alias v="nvim"
