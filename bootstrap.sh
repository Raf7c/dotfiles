#!/bin/sh
# ==========================================
# ~/bootstrap.sh
# ==========================================

set -eu

echo "🚀 macOS Environment Configuration"

# macOS verification(Darwin)
if [ "$(uname -s)" != "Darwin" ]; then
    printf '%s\n' "❌ This script must be run on macOS" >&2
    exit 1
fi

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

# Simplified sequential execution
echo "🔗 Creating symbolic links..."
sh "$SCRIPT_DIR/install/link_global.sh"

echo "🍺 Configuring Homebrew..."
sh "$SCRIPT_DIR/install/macOS/homebrew.sh"

echo "📚 Configuring shell..."
# Source shell environment if available
if [ -f ~/.zshenv ]; then
    source ~/.zshenv
else
    echo "⚠️ ~/.zshenv not found, skipping shell environment loading"
fi
sh "$SCRIPT_DIR/install/shell.sh"

echo "⚙️ Configuring macOS..."
sh "$SCRIPT_DIR/install/macOS/osx.sh"

echo "🎉 Configuration completed!"
echo "💡 Some changes may require a full restart."