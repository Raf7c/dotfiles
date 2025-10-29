#!/bin/sh
# ==========================================
# ~/install/fedora/packages.sh
# Install packages on Fedora with DNF
# ==========================================

set -eu

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
PACKAGES_DIR="$SCRIPT_DIR/../packages"

echo "📦 Installing packages..."

# Update system
echo "🔄 Updating system..."
sudo dnf update -y -q

# Function to install package with DNF
install_pkg() {
    pkg="$1"
    [ -z "$pkg" ] && return
    case "$pkg" in \#*) return ;; esac
    
    sudo dnf install -y -q "$pkg" 2>/dev/null || true
}

# Install Fedora packages
echo "📦 Installing Fedora packages..."
while IFS= read -r pkg || [ -n "$pkg" ]; do
    install_pkg "$pkg"
done < "$PACKAGES_DIR/fedora.txt" || true

# Cleanup
sudo dnf autoremove -y -q 2>/dev/null || true
echo "✅ Installation complete!"
