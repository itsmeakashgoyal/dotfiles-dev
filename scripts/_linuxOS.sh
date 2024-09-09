#!/usr/bin/env bash

set -eo pipefail
IFS=$'\n\t'

user=$(whoami)

process() {
	echo "$(date) PROCESSING:  $@" >>$LOG
	printf "$(tput setaf 6) [STEP ${STEP:-0}] %s...$(tput sgr0)\n" "$@"
	STEP=$((STEP + 1))
}

process "→ Bootstrap steps start here:\n------------------"

sudo apt-get update
sudo apt-get -y upgrade

process "→ install git"
sudo apt install -y git

process "→ setup git config"
sh ~/dotfiles-dev/scripts/_git_config.sh

process "→ install essential packages"
sudo apt install -y vim-gtk htop unzip python3-setuptools tmux pydf wget jq bat locate libgraph-easy-perl stow cowsay
sudo apt install -y fuse xclip xsel fd-find expect curl ripgrep

process "→ install pip"
sudo apt install -y python3-pip

process "→ install exa"
EXA_VERSION=$(curl -s "https://api.github.com/repos/ogham/exa/releases/latest" | grep -Po '"tag_name": "v\K[0-9.]+')
curl -Lo exa.zip "https://github.com/ogham/exa/releases/latest/download/exa-linux-x86_64-v${EXA_VERSION}.zip"
sudo unzip -q exa.zip bin/exa -d /usr/local
sudo rm exa.zip

process "→ Installing eza"
sudo apt install -y gpg
sudo mkdir -p /etc/apt/keyrings
wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
sudo apt update
sudo apt install -y eza

process "→ install go"
curl -LO https://go.dev/dl/go1.23.0.linux-amd64.tar.gz
sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go1.23.0.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin
go version

process "→ Install antidote"
git clone --depth=1 https://github.com/mattmc3/antidote.git ${ZDOTDIR:-~}/.antidote

process "→ Install development tools and package managers"
sudo apt install -y cargo
cargo install just
cargo install zoxide
cargo install onefetch

process "→ install node and npm"
sudo apt install -y nodejs
sudo apt install -y npm

process "→ Installing fzf"
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all

process "→ install zsh and oh-my-zsh"
sudo apt install -y zsh
sudo rm -rf ~/.oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

process "→ Installing oh-my-zsh plugins"
git clone https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/Aloxaf/fzf-tab ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab
git clone https://github.com/jeffreytse/zsh-vi-mode $ZSH_CUSTOM/plugins/zsh-vi-mode

# sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="3den"/g' ~/.zshrc
# echo 'export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"' >>~/.zshrc
process "→ Setting zsh as default shell"
# add zsh as a login shell
command -v zsh | sudo tee -a /etc/shells
# use zsh as default shell
sudo chsh -s $(which zsh) $USER

process "→ Installing Neovim"
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux64.tar.gz
export PATH="$PATH:/opt/nvim-linux64/bin"

process "→ Installing diff-so-fancy"
LATEST_VERSION=$(curl -s https://api.github.com/repos/so-fancy/diff-so-fancy/releases/latest | grep -Po '"tag_name": "v\K[^"]*')
sudo curl -L -o /usr/local/bin/diff-so-fancy "https://github.com/so-fancy/diff-so-fancy/releases/download/v${LATEST_VERSION}/diff-so-fancy"
sudo chmod +x /usr/local/bin/diff-so-fancy

process "→ Installing nix package manager"
sh <(curl -L https://nixos.org/nix/install) --daemon
# source nix
. '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'

process "→ Installing nix packages"
sh ~/dotfiles-dev/scripts/_nix-packages.sh

source ~/.zshrc
exec zsh

process "→ Installation complete"
