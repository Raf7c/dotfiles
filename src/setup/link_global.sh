#!/bin/sh
# ==========================================
# ~/src/setup/link_global.sh 
# Creating symbolic links
# ==========================================

set -eu

# Create directories
mkdir -p "$HOME/.config"
mkdir -p "$HOME/.local/bin"

# Global .config links
ln -sfn "$HOME/.dotfiles/.config/bat"            "$HOME/.config/bat"
ln -sfn "$HOME/.dotfiles/.config/tmux"           "$HOME/.config/tmux"
ln -sfn "$HOME/.dotfiles/.config/nvim"           "$HOME/.config/nvim"
ln -sfn "$HOME/.dotfiles/.config/starship.toml"  "$HOME/.config/starship.toml"
ln -sfn "$HOME/.dotfiles/.config/ghostty"        "$HOME/.config/ghostty"
ln -sfn "$HOME/.dotfiles/.config/shell"          "$HOME/.config/shell"
ln -sfn "$HOME/.dotfiles/.config/git"            "$HOME/.config/git"

# Login shell links (zsh and bash)
ln -sfn "$HOME/.dotfiles/zsh/.zprofile"          "$HOME/.zprofile"
ln -sfn "$HOME/.dotfiles/zsh/.zshrc"             "$HOME/.zshrc"
ln -sfn "$HOME/.dotfiles/bash/.bash_profile"     "$HOME/.bash_profile"
ln -sfn "$HOME/.dotfiles/bash/.bashrc"           "$HOME/.bashrc"

# Global $Home links
ln -sfn "$HOME/.dotfiles/.tool-versions"         "$HOME/.tool-versions"
ln -sfn "$HOME/.dotfiles/.vimrc"                 "$HOME/.vimrc"

# iCloud Drive shortcut
ln -sfn "$HOME/Library/Mobile Documents/com~apple~CloudDocs" "$HOME/iCloudDrive"