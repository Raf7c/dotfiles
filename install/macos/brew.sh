#!/bin/bash
# Homebrew: check, install if needed, then run Brewfile

set -eu

if ! command -v brew >/dev/null 2>&1 && ! [ -x /opt/homebrew/bin/brew ]; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo "Homebrew installed."
fi

DOTS_ROOT="${DOTS_ROOT:-$(cd "$(dirname "$0")/../.." && pwd)}"
[ -f "$DOTS_ROOT/.config/shell/env" ] && . "$DOTS_ROOT/.config/shell/env"

echo "Updating Homebrew..."
brew update

BREWFILE="$DOTS_ROOT/Brewfile"
if [ -f "$BREWFILE" ]; then
  echo "Installing Brewfile packages..."
  brew bundle --file="$BREWFILE"
  echo "Brewfile done."
else
  echo "Brewfile not found: $BREWFILE"
fi

echo "Upgrading installed packages..."
brew upgrade

echo "Cleaning up..."
brew cleanup
