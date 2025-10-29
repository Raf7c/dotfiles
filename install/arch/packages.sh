#!/bin/sh
# ==========================================
# ~/install/arch/packages.sh
# Install packages on Arch Linux with Pacman
# ==========================================

set -eu

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
PACKAGES_DIR="$SCRIPT_DIR/../packages"

# Load unified package installer
. "$SCRIPT_DIR/../lib/install_packages.sh"

# Install packages
install_packages "arch" "$PACKAGES_DIR"
