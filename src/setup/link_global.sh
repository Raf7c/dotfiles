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
ln -sf "$HOME/.dotfiles/.config/bat"            "$HOME/.config/bat"
ln -sf "$HOME/.dotfiles/.config/tmux"           "$HOME/.config/tmux"
ln -sf "$HOME/.dotfiles/.config/nvim"           "$HOME/.config/nvim"
ln -sf "$HOME/.dotfiles/.config/starship.toml"  "$HOME/.config/starship.toml"
ln -sf "$HOME/.dotfiles/.config/ghostty"        "$HOME/.config/ghostty"
ln -sf "$HOME/.dotfiles/.config/shell"          "$HOME/.config/shell"
ln -sf "$HOME/.dotfiles/.config/git"            "$HOME/.config/git"

# Login shell links (zsh and bash)
ln -sf "$HOME/.dotfiles/zsh/.zprofile"          "$HOME/.zprofile"
ln -sf "$HOME/.dotfiles/zsh/.zshrc"             "$HOME/.zshrc"
ln -sf "$HOME/.dotfiles/bash/.bash_profile"     "$HOME/.bash_profile"
ln -sf "$HOME/.dotfiles/bash/.bashrc"           "$HOME/.bashrc"

# Global $Home links
ln -sf "$HOME/.dotfiles/.tool-versions"         "$HOME/.tool-versions"
ln -sf "$HOME/.dotfiles/.vimrc"                 "$HOME/.vimrc"