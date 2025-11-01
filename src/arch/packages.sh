#!/bin/sh
# ==========================================
# ~/.dotfiles/src/arch/packages.sh
# Install packages on Arch Linux with Pacman
# ==========================================

set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
ARCH_PACKAGES="$SCRIPT_DIR/arch.txt"

# Load utilities
. "$SCRIPT_DIR/../lib/utils.sh"

# Load unified package manager
. "$SCRIPT_DIR/../lib/package_manager.sh"

# Install packages
install_packages "arch" "$ARCH_PACKAGES"
