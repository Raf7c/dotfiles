#!/bin/sh
# ==========================================
# ~/bootstrap.sh
# ==========================================

set -eu

echo "🚀 macOS Environment Configuration"

# macOS verification (more concise)
[ "$(uname -s)" = "Darwin" ] || { echo "❌ This script must be run on macOS" >&2; exit 1; }

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

# Simplified sequential execution
echo "🔗 Creating symbolic links..."
sh "$SCRIPT_DIR/install/link_global.sh"

echo "🍺 Configuring Homebrew..."
sh "$SCRIPT_DIR/install/macOS/homebrew.sh"

echo "📚 Configuring shell..."
source ~/.zshenv
sh "$SCRIPT_DIR/install/shell.sh"

echo "⚙️ Configuring macOS..."
sh "$SCRIPT_DIR/install/macOS/osx.sh"

echo "🎉 Configuration completed!"
echo "💡 Some changes may require a full restart."