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

echo "🔧 Generating GCC cache..."
sh "$SCRIPT_DIR/install/macOS/refresh-gcc-cache.sh"

echo "📚 Configuring shell..."
# Source shell environment if available
if [ -f ~/.zshenv ]; then
    . ~/.zshenv
else
    echo "⚠️ ~/.zshenv not found, skipping shell environment loading"
fi
sh "$SCRIPT_DIR/install/shell.sh"

echo "🖥️ Installing Tmux plugins..."
sh "$SCRIPT_DIR/install/tmux-tmp.sh"

echo "⚙️ Configuring macOS..."
sh "$SCRIPT_DIR/install/macOS/osx.sh"

echo "⚙️ Installing plugins asdf and versions..."
sh "$SCRIPT_DIR/install/asdf-install.sh"

echo "🎉 Configuration completed!"
echo "💡 Some changes may require a full restart."