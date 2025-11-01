#!/bin/sh
# ==========================================
# ~/link_global.sh 
# Creating symbolic links
# ==========================================

set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

# Load utilities
. "$SCRIPT_DIR/../../lib/utils.sh"
. "$SCRIPT_DIR/../../lib/helpers.sh"

echo "🔗 Creating symbolic links..."

# Create directories
ensure_directory "$HOME/.config"
ensure_directory "$HOME/.local/bin"

# Config links (with safe_link)
for item in git ghostty shell bat tmux; do
    safe_link "$HOME/.dotfiles/.config/$item" "$HOME/.config/$item"
done

# Starship config (file, not directory)
safe_link "$HOME/.dotfiles/.config/starship.toml" "$HOME/.config/starship.toml"

# Login shell links
safe_link "$HOME/.dotfiles/zsh/.zprofile" "$HOME/.zprofile"
safe_link "$HOME/.dotfiles/zsh/.zshrc" "$HOME/.zshrc"
safe_link "$HOME/.dotfiles/bash/.bash_profile" "$HOME/.bash_profile"
safe_link "$HOME/.dotfiles/bash/.bashrc" "$HOME/.bashrc"

# asdf links
safe_link "$HOME/.dotfiles/.tool-versions" "$HOME/.tool-versions"

# Vim links
safe_link "$HOME/.dotfiles/.vimrc" "$HOME/.vimrc"

print_success "Symbolic links created!"