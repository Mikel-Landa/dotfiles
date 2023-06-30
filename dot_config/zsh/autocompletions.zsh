
# Load completions folder
fpath=($HOME/.config/zsh/completions/ $fpath)

# FZF
source /usr/share/doc/fzf/examples/completion.zsh
# ASDF
fpath=($HOME/.config/zsh/completions/ ${ASDF_DIR}/completions $fpath)
