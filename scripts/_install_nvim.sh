#!/usr/bin/env bash

# Enable strict mode
set -euo pipefail
IFS=$'\n\t'

# Function to log and display process steps
process() {
    echo "$(date) PROCESSING:  $@" >> "$LOG"
    printf "$(tput setaf 6) [STEP ${STEP:-0}] %s...$(tput sgr0)\n" "$@"
    STEP=$((STEP + 1))
}

# Check if the home directory and linuxtoolbox folder exist, create them if they don't
LINUXTOOLBOXDIR="$HOME/linuxtoolbox"

if [[ ! -d "$LINUXTOOLBOXDIR" ]]; then
    echo -e "${YELLOW}Creating linuxtoolbox directory: $LINUXTOOLBOXDIR${RC}"
    mkdir -p "$LINUXTOOLBOXDIR"
    echo -e "${GREEN}linuxtoolbox directory created: $LINUXTOOLBOXDIR${RC}"
fi

# Backup existing neovim config and install new one
mkdir -p "$LINUXTOOLBOXDIR/backup/nvim"
[ -d ~/.config/nvim ] && cp -r ~/.config/nvim "$LINUXTOOLBOXDIR/backup/nvim/config"
[ -d ~/.local/share/nvim ] && cp -r ~/.local/share/nvim "$LINUXTOOLBOXDIR/backup/nvim/local_share"
[ -d ~/.cache/nvim ] && cp -r ~/.cache/nvim "$LINUXTOOLBOXDIR/backup/nvim/cache"
rm -rf ~/.config/nvim ~/.local/share/nvim ~/.cache/nvim

process "→ Installing Neovim"
NVIM_VERSION=$(curl -s https://api.github.com/repos/neovim/neovim/releases/latest | grep -Po '"tag_name": "v\K[^"]*')
curl -LO "https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz"
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux64.tar.gz
rm nvim-linux64.tar.gz
echo 'export PATH="$PATH:/opt/nvim-linux64/bin"' >> ~/.zshrc
source ~/.zshrc

# Share system clipboard with unnamedplus
if [ -f /etc/os-release ]; then
    . /etc/os-release
    # Determine if Wayland or Xorg is being used
    if [[ $XDG_SESSION_TYPE == "wayland" ]]; then
        CLIPBOARD_PKG="wl-clipboard"
    else
        CLIPBOARD_PKG="xclip"
    fi

    case "${ID_LIKE:-$ID}" in
        debian|ubuntu)
            sudo apt install ripgrep fd-find $CLIPBOARD_PKG python3-venv luarocks golang-go shellcheck -y
            ;;
        fedora)
            sudo dnf install ripgrep fzf $CLIPBOARD_PKG neovim python3-virtualenv luarocks golang ShellCheck -y
            ;;
        arch|manjaro)
            sudo pacman -S ripgrep fzf $CLIPBOARD_PKG neovim python-virtualenv luarocks go shellcheck --noconfirm
            ;;
        opensuse)
            sudo zypper install ripgrep fzf $CLIPBOARD_PKG neovim python3-virtualenv luarocks go ShellCheck -y
            ;;
        *)
            echo -e "${YELLOW}Unsupported OS. Please install the following packages manually:${RC}"
            echo "ripgrep, fzf, $CLIPBOARD_PKG, neovim, python3-virtualenv (or equivalent), luarocks, go, shellcheck"
            ;;
    esac
else
    echo -e "${RED}Unable to determine OS. Please install required packages manually.${RC}"
fi
