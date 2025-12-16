#!/bin/sh

set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
DOTS_ROOT="$SCRIPT_DIR"

echo "🔄 Updating dotfiles..."
echo ""

# 1. Update Git repository
echo "📥 Updating Git repository..."
if git -C "$DOTS_ROOT" diff-index --quiet HEAD --; then
    # No modifications, pull directly
    git -C "$DOTS_ROOT" pull --rebase
else
    # Modifications detected, stash then pull
    echo "  ⚠️  Modifications detected, temporary backup..."
    git -C "$DOTS_ROOT" stash push -m "Auto-stash before update $(date +%Y-%m-%d_%H:%M:%S)"
    git -C "$DOTS_ROOT" pull --rebase
    echo "  ♻️  Restoring modifications..."
    git -C "$DOTS_ROOT" stash pop || echo "  ⚠️  Conflicts detected, check with: git status"
fi

# 2. Update submodules
echo "📦 Updating submodules..."
git submodule update --init --recursive --remote
git submodule foreach 'git checkout main || true'

# 3. Update Homebrew
echo "🍺 Updating Homebrew..."
if command -v brew >/dev/null 2>&1; then
    brew update
    echo "📦 Upgrading Homebrew packages..."
    brew upgrade
    echo "🧹 Cleaning up..."
    brew cleanup
else
    echo "⚠️  Homebrew not found, skipping..."
fi

# 4. Install new packages from Brewfile
echo "📦 Installing new packages..."
sh "$DOTS_ROOT/src/macOS/homebrew.sh"

# 5. Recreate symbolic links
echo "🔗 Updating symbolic links..."
sh "$DOTS_ROOT/src/setup/link_global.sh"

# 6. Update asdf and its plugins
echo "🔧 Updating asdf plugins..."
if command -v asdf >/dev/null 2>&1; then
    echo "  → Updating asdf..."
    asdf update || true
    
    echo "  → Updating asdf plugins..."
    asdf plugin update --all || true
    
    echo "  → Installing new versions..."
    sh "$DOTS_ROOT/src/setup/asdf.sh"
else
    echo "⚠️  asdf not found, skipping..."
fi

# 7. Update TPM and Tmux plugins
echo "🔌 Updating Tmux plugins..."
TPM_DIR="$HOME/.config/tmux/plugins/tpm"
if [ -d "$TPM_DIR" ]; then
    echo "  → Updating TPM..."
    git -C "$TPM_DIR" pull
    echo "  💡 Launch Tmux and press Ctrl+Space + U to update plugins"
else
    echo "  → Installing TPM..."
    sh "$DOTS_ROOT/src/setup/tmux.sh"
fi

# 8. Update Zinit
echo "⚡ Updating Zinit..."
ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"
if [ -d "$ZINIT_HOME" ]; then
    git -C "$ZINIT_HOME" pull
    echo "  💡 Zsh plugins will be updated on next startup"
else
    echo "⚠️  Zinit not found, skipping..."
fi

# 9. Regenerate GCC cache
echo "🔄 Regenerating GCC cache..."
sh "$DOTS_ROOT/src/macOS/refresh-gcc-cache.sh"

# 10. Clean caches
echo "🧹 Cleaning caches..."
rm -f "$HOME/.zcompdump"*

echo ""
echo "✅ Update completed!"
echo ""
echo "💡 Next steps:"
echo "  → Restart your terminal: exec zsh"
echo ""
