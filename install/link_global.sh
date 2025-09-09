#!/bin/sh
# ==========================================
# ~/link_global.sh 
# ==========================================

set -eu
# Ensure ~/.config exists
[ -d "$HOME/.config" ] || mkdir -p "$HOME/.config"

# .config
ln -sfn "$HOME/.dotfiles/.config/kitty" "$HOME/.config/kitty"
ln -sfn "$HOME/.dotfiles/.config/git" 	"$HOME/.config/git"
ln -sfn "$HOME/.dotfiles/.vimrc"	"$HOME/.vimrc"

# Zsh
ln -sfn "$HOME/.dotfiles/zsh/.zshenv"   "$HOME/.zshenv"
ln -sfn "$HOME/.dotfiles/zsh/.zprofile" "$HOME/.zprofile"
ln -sfn "$HOME/.dotfiles/zsh/.zshrc"    "$HOME/.zshrc"

# Bash
ln -sfn "$HOME/.dotfiles/bash/.bashrc"	"$HOME/.bashrc"
