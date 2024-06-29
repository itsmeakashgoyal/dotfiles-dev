#!/usr/bin/env bash
############################
# This script stow the dotfiles
# And also installs MacOS Software
# And also installs Homebrew Packages and Casks (Apps)
# And also sets up VS Code
# And also sets up Sublime Text
############################
stow .

# Run the MacOS Script
./scripts/macOS.sh

# Run the Homebrew Script
./scripts/brew.sh

# Run VS Code Script
./scripts/vscode.sh

# Run the Sublime Script
./scripts/sublime.sh

echo "Installation Complete!"