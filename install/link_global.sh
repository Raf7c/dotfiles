#!/bin/sh
# ==========================================
# ~/link_global.sh (POSIX minimal)
# ==========================================

set -eu

# Assure que ~/.config existe
[ -d "$HOME/.config" ] || mkdir -p "$HOME/.config"

# .config
ln -sfn "$HOME/.dotfiles/.config/kitty" "$HOME/.config/kitty"
ln -sfn "$HOME/.dotfiles/.config/git" 	"$HOME/.config/git"

# Zsh à la racine (convention)
ln -sfn "$HOME/.dotfiles/zsh/.zshenv"   "$HOME/.zshenv"
ln -sfn "$HOME/.dotfiles/zsh/.zprofile" "$HOME/.zprofile"
ln -sfn "$HOME/.dotfiles/zsh/.zshrc"    "$HOME/.zshrc"
