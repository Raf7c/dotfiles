#!/bin/sh
# ==========================================
# ~/update.sh
# Update environment
# ==========================================

set -eu

# Start timer
START_TIME=$(date +%s)

# macOS verification(Darwin)
if [ "$(uname -s)" != "Darwin" ]; then
    printf '%s\n' "❌ This script must be run on macOS" >&2
    exit 1
fi

echo "🚀 macOS Environment Update"
echo "📅 Started at: $(date '+%Y-%m-%d %H:%M:%S')"
echo ""

# 1. Homebrew
if command -v brew >/dev/null 2>&1; then
    echo "🍺 Updating Homebrew..."
    brew update
    brew upgrade
    brew cleanup
    echo "✅ Homebrew updated successfully"

    echo "🔧 Refreshing GCC cache..."
    sh "$HOME/.dotfiles/install/macOS/refresh-gcc-cache.sh"
else
    echo "⚠️ Homebrew not found, skipping Homebrew updates"
fi

# 2. Zinit
if command -v zsh >/dev/null 2>&1; then
    echo "🐚 Updating Zsh plugins..."
    if zsh -i -c "zinit self-update && zinit update" 2>/dev/null; then
        echo "✅ Zinit plugins updated successfully"
    else
        echo "⚠️ Zinit not available or update failed"
    fi
else
    printf '%s\n' "⚠️ zsh not found, skipping plugin update"
fi

# Calculate duration
END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))
MINUTES=$((DURATION / 60))
SECONDS=$((DURATION % 60))

# Summary
echo "========================================="
echo "🎉 Update completed!"
echo "⏱️  Total time: ${MINUTES}m ${SECONDS}s"
echo "========================================="

