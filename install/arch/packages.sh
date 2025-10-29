#!/bin/sh
# ==========================================
# ~/install/arch/packages.sh
# Install packages on Arch Linux with Pacman
# ==========================================

set -eu

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
PACKAGES_DIR="$SCRIPT_DIR/../packages"

echo "📦 Installing packages..."

# Update system
echo "🔄 Updating system..."
sudo pacman -Syu --noconfirm

# Function to install package with Pacman
install_pkg() {
    pkg="$1"
    [ -z "$pkg" ] && return
    case "$pkg" in \#*) return ;; esac
    
    sudo pacman -S --noconfirm --needed "$pkg" 2>/dev/null || true
}

# Install Arch packages
echo "🏔️  Installing Arch packages..."
while IFS= read -r pkg || [ -n "$pkg" ]; do
    install_pkg "$pkg"
done < "$PACKAGES_DIR/arch.txt" || true

# Cleanup
sudo pacman -Sc --noconfirm 2>/dev/null || true
echo "✅ Installation complete!"
