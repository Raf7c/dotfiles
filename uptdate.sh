#!/bin/sh
# ==========================================
# ~/update.sh
# ==========================================

set -eu

# macOS verification(Darwin)
if [ "$(uname -s)" != "Darwin" ]; then
    printf '%s\n' "❌ This script must be run on macOS" >&2
    exit 1
fi

printf '%s\n' "🚀 macOS Environment Update"

# 1. Homebrew
brew update
brew upgrade
brew cleanup

# 2. Zinit
if command -v zsh >/dev/null 2>&1; then
    zsh -i -c "zinit self-update && zinit update"
else
    printf '%s\n' "⚠️  zsh not found, skipping plugin update"
fi

