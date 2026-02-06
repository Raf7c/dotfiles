#!/bin/bash
# Liens symboliques pour la config (macOS)

set -eu

DOTS_ROOT="${DOTS_ROOT:-$(cd "$(dirname "$0")/../.." && pwd)}"

mkdir -p "$HOME/.config"

ln -sfn "$DOTS_ROOT/.config/git" "$HOME/.config/git"
echo "Lien créé : $HOME/.config/git -> $DOTS_ROOT/.config/git"

ln -sfn "$DOTS_ROOT/.config/shell" "$HOME/.config/shell"
echo "Lien créé : $HOME/.config/shell -> $DOTS_ROOT/.config/shell"

ln -sfn "$DOTS_ROOT/.config/zsh" "$HOME/.config/zsh"
echo "Lien créé : $HOME/.config/zsh -> $DOTS_ROOT/.config/zsh"

ln -sfn "$DOTS_ROOT/.config/starship.toml" "$HOME/.config/starship.toml"
echo "Lien créé : $HOME/.config/starship.toml -> $DOTS_ROOT/.config/starship.toml"

ln -sfn "$DOTS_ROOT/.config/ghostty" "$HOME/.config/ghostty"
echo "Lien créé : $HOME/.config/ghostty -> $DOTS_ROOT/.config/ghostty"

ln -sfn "$DOTS_ROOT/.config/bat" "$HOME/.config/bat"
echo "Lien créé : $HOME/.config/bat -> $DOTS_ROOT/.config/bat"

ln -sfn "$DOTS_ROOT/.config/tmux" "$HOME/.config/tmux"
echo "Lien créé : $HOME/.config/tmux -> $DOTS_ROOT/.config/tmux"

ln -sfn "$DOTS_ROOT/.bashrc" "$HOME/.bashrc"
echo "Lien créé : $HOME/.bashrc -> $DOTS_ROOT/.bashrc"

ln -sfn "$DOTS_ROOT/.zshrc" "$HOME/.zshrc"
echo "Lien créé : $HOME/.zshrc -> $DOTS_ROOT/.zshrc"

ln -sfn "$DOTS_ROOT/.tool-versions" "$HOME/.tool-versions"
echo "Lien créé : $HOME/.tool-versions -> $DOTS_ROOT/.tool-versions"