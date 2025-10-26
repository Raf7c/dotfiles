#!/bin/sh
# ==========================================
# ~/link_global.sh 
# ==========================================

set -eu

echo "🔗 Creating symbolic links..."

# Create directories
mkdir -p "$HOME/.config"
mkdir -p "$HOME/.local/bin"

# Config links
ln -sfn "$HOME/.dotfiles/.config/kitty"		"$HOME/.config/kitty"
ln -sfn "$HOME/.dotfiles/.config/git"		"$HOME/.config/git"
ln -sfn "$HOME/.dotfiles/.config/starship.toml" "$HOME/.config/starship.toml"
ln -sfn "$HOME/.dotfiles/.config/ghostty"   "$HOME/.config/ghostty"
ln -sfn "$HOME/.dotfiles/.config/shell" "$HOME/.config/shell"
ln -sfn "$HOME/.dotfiles/.config/bat" "$HOME/.config/bat"
ln -sfn "$HOME/.dotfiles/.config/tmux" "$HOME/.config/tmux"

# Login shell links
ln -sfn "$HOME/.dotfiles/zsh/.zshenv" "$HOME/.zshenv"
ln -sfn "$HOME/.dotfiles/zsh/.zprofile" "$HOME/.zprofile"
ln -sfn "$HOME/.dotfiles/zsh/.zshrc" "$HOME/.zshrc"
ln -sfn "$HOME/.dotfiles/bash/.bash_profile" "$HOME/.bash_profile"
ln -sfn "$HOME/.dotfiles/bash/.bashrc" "$HOME/.bashrc"

# asdf links
ln -sfn "$HOME/.dotfiles/.tool-versions" "$HOME/.tool-versions"

# Vim links
ln -sfn "$HOME/.dotfiles/.vimrc" "$HOME/.vimrc"