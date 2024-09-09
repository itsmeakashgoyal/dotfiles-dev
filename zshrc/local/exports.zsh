# ------------------------------------------------------------------------------
# General Exports
# ------------------------------------------------------------------------------

# Prefer US English and use UTF-8.
export LANG='en_US.UTF-8';
export LC_ALL='en_US.UTF-8';

# colorful man pages
export LESS_TERMCAP_mb=$'\e[1;31m'
export LESS_TERMCAP_md=$'\e[1;31m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;32m'

## export PATH
export PATH=$HOME/.local/bin:$PATH
export PATH=$PATH:~/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin
export PATH=$PATH:/usr/local/bin/clang-15:/usr/local/compilers/clang15/bin
export PATH=$PATH:$HOME/.local/share/gem/ruby/3.0.0/bin
export PATH=$PATH:/opt/nvim-linux64/bin
export PATH=$PATH:$HOME/.fzf/bin
export PATH=$PATH:/usr/local/go/bin

# ~/.config/tmux/plugins
export PATH=$PATH:$HOME/.config/tmux/plugins/t-smart-tmux-session-manager/bin

# the detailed meaning of the below three variable can be found in `man zshparam`.
HISTSIZE=1000000  # the number of items for the internal history list
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE  # maximum number of items for the history file
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups # do not put duplicated command into history list
setopt hist_save_no_dups  # do not save duplicated command
setopt hist_ignore_dups
setopt hist_find_no_dups
# setopt EXTENDED_HISTORY  # record command start time
