#!/bin/sh
# ==========================================
# ~/install/macOS/packages.sh
# Install packages on macOS with Homebrew
# ==========================================

set -eu

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
PACKAGES_DIR="$SCRIPT_DIR/../packages"

echo "📦 Installing packages..."

# Verify Homebrew is available
if ! command -v brew >/dev/null 2>&1; then
    echo "❌ Homebrew not available" >&2
    exit 1
fi

# Function to install package
install_pkg() {
    pkg="$1"
    [ -z "$pkg" ] && return
    case "$pkg" in \#*) return ;; esac
    
    # Check if package has cask: prefix
    if echo "$pkg" | grep -q "^cask:"; then
        # Remove cask: prefix and install as cask
        cask_name=$(echo "$pkg" | sed 's/^cask://')
        brew install --cask "$cask_name" 2>/dev/null || true
    else
        # Regular formula
        brew install "$pkg" 2>/dev/null || true
    fi
}

# Install macOS packages
echo "🍎 Installing macOS packages..."
while IFS= read -r pkg || [ -n "$pkg" ]; do
    install_pkg "$pkg"
done < "$PACKAGES_DIR/macos.txt" || true

brew cleanup -q 2>/dev/null || true
echo "✅ Installation complete!"
