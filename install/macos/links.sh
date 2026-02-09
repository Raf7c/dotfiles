#!/bin/bash
# Symbolic links for config (macOS)

set -eu

DOTS_ROOT="${DOTS_ROOT:-$(cd "$(dirname "$0")/../.." && pwd)}"

mkdir -p "$HOME/.config"

ln -sfn "$DOTS_ROOT/.config/git" "$HOME/.config/git"
echo "Link created: $HOME/.config/git -> $DOTS_ROOT/.config/git"

ln -sfn "$DOTS_ROOT/.config/shell" "$HOME/.config/shell"
echo "Link created: $HOME/.config/shell -> $DOTS_ROOT/.config/shell"

ln -sfn "$DOTS_ROOT/.config/zsh" "$HOME/.config/zsh"
echo "Link created: $HOME/.config/zsh -> $DOTS_ROOT/.config/zsh"

ln -sfn "$DOTS_ROOT/.config/starship.toml" "$HOME/.config/starship.toml"
echo "Link created: $HOME/.config/starship.toml -> $DOTS_ROOT/.config/starship.toml"

ln -sfn "$DOTS_ROOT/.config/ghostty" "$HOME/.config/ghostty"
echo "Link created: $HOME/.config/ghostty -> $DOTS_ROOT/.config/ghostty"

ln -sfn "$DOTS_ROOT/.config/kitty" "$HOME/.config/kitty"
echo "Link created: $HOME/.config/kitty -> $DOTS_ROOT/.config/kitty"

ln -sfn "$DOTS_ROOT/.config/bat" "$HOME/.config/bat"
echo "Link created: $HOME/.config/bat -> $DOTS_ROOT/.config/bat"

ln -sfn "$DOTS_ROOT/.config/tmux" "$HOME/.config/tmux"
echo "Link created: $HOME/.config/tmux -> $DOTS_ROOT/.config/tmux"

ln -sfn "$DOTS_ROOT/.bashrc" "$HOME/.bashrc"
echo "Link created: $HOME/.bashrc -> $DOTS_ROOT/.bashrc"

ln -sfn "$DOTS_ROOT/.zshrc" "$HOME/.zshrc"
echo "Link created: $HOME/.zshrc -> $DOTS_ROOT/.zshrc"

ln -sfn "$DOTS_ROOT/.tool-versions" "$HOME/.tool-versions"
echo "Link created: $HOME/.tool-versions -> $DOTS_ROOT/.tool-versions"