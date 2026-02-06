#!/bin/bash
# Homebrew : vérification, installation si besoin, puis Brewfile

set -eu

if ! command -v brew >/dev/null 2>&1 && ! [ -x /opt/homebrew/bin/brew ]; then
  echo "Installation de Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo "Homebrew installé."
fi

DOTS_ROOT="${DOTS_ROOT:-$(cd "$(dirname "$0")/../.." && pwd)}"
[ -f "$DOTS_ROOT/.config/shell/env" ] && . "$DOTS_ROOT/.config/shell/env"

echo "Mise à jour de Homebrew..."
brew update

BREWFILE="$DOTS_ROOT/Brewfile"
if [ -f "$BREWFILE" ]; then
  echo "Installation des paquets du Brewfile..."
  brew bundle --file="$BREWFILE"
  echo "Brewfile terminé."
else
  echo "Brewfile introuvable : $BREWFILE"
fi

echo "Mise à jour des paquets installés..."
brew upgrade

echo "Nettoyage..."
brew cleanup
