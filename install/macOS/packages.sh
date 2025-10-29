#!/bin/sh
# ==========================================
# ~/install/macOS/packages.sh
# Install packages on macOS with Homebrew
# ==========================================

set -eu

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
PACKAGES_DIR="$SCRIPT_DIR/../packages"

# Load unified package installer
. "$SCRIPT_DIR/../lib/install_packages.sh"

# Install packages
install_packages "macos" "$PACKAGES_DIR"
