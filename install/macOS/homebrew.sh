#!/bin/sh
# ==========================================
# ~/homebrew.sh
# ==========================================

set -eu

echo "🔍 Checking Homebrew..."

# Initialize Homebrew (Apple Silicon only)
if command -v brew >/dev/null 2>&1; then
    echo "✅ Homebrew already available"
elif [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
    echo "ℹ️ Homebrew detected and added to PATH"
else
    echo "⬇️ Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # Initialize after installation (Apple Silicon only)
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Source shell environment to get Homebrew configuration
echo "🔧 Loading shell environment..."
[ -f "$HOME/.zprofile" ] && . "$HOME/.zprofile"

echo "✅ Homebrew ready: $(brew --version | head -n1)"

# Install from Brewfile
BREWFILE="${1:-$HOME/.dotfiles/Brewfile}"
[ -f "$BREWFILE" ] || { echo "❌ Brewfile not found: $BREWFILE" >&2; exit 1; }

echo "📦 Installing from $BREWFILE..."
brew bundle --file="$BREWFILE"
echo "✅ Installation completed!"
