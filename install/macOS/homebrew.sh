#!/bin/sh
# ==========================================
# ~/homebrew.sh
# ==========================================

set -eu

echo "🔍 Checking Homebrew..."

# More robust and faster detection
if command -v brew >/dev/null 2>&1; then
    echo "✅ Homebrew already available"
elif [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
    echo "ℹ️ Homebrew detected and added to PATH"
else
    echo "⬇️ Installing Homebrew..."
    /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# More concise version display
echo "✅ Homebrew ready: $(brew --version | head -n1)"

# Brewfile with simplified verification
BREWFILE="${1:-$HOME/.dotfiles/Brewfile}"
[ -f "$BREWFILE" ] || { echo "❌ Brewfile not found: $BREWFILE" >&2; exit 1; }

echo "📦 Installing from $BREWFILE..."
brew bundle --file="$BREWFILE"
echo "✅ Completed!"