# ------------------------------------------------------------------------------
# Aliases and functions for Vim
# ------------------------------------------------------------------------------

# Set default editor
export EDITOR='/opt/nvim-linux64/bin/nvim'

alias vim='nvim'

# Open vim with z argument
v() {
    if [ -n "$1" ]; then
        z $1
    fi
    $EDITOR
}
