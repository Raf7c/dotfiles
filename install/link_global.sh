#!/bin/sh
# ==========================================
# ~/link_global.sh 
# ==========================================

set -eu

echo "🔗 Creating symbolic links..."

# Create .config directory
mkdir -p "$HOME/.config"

# .config links
ln -sfn "$HOME/.dotfiles/.config/kitty"		"$HOME/.config/kitty"
ln -sfn "$HOME/.dotfiles/.config/git"		"$HOME/.config/git"
ln -sfn "$HOME/.dotfiles/.config/starship"  "$HOME/.config/starship"
ln -sfn "$HOME/.dotfiles/.config/ghostty"   "$HOME/.config/ghostty"

# Shell links
ln -sfn "$HOME/.dotfiles/zsh/.zshenv" "$HOME/.zshenv"
ln -sfn "$HOME/.dotfiles/zsh/.zprofile" "$HOME/.zprofile"
ln -sfn "$HOME/.dotfiles/zsh/.zshrc" "$HOME/.zshrc"
ln -sfn "$HOME/.dotfiles/bash/.bashrc" "$HOME/.bashrc"

# Vim links
ln -sfn "$HOME/.dotfiles/.vimrc" "$HOME/.vimrc"

echo "✅ Symbolic links created"
