#!/bin/sh
# ==========================================
# ~/.dotfiles/src/macOS/packages.sh
# Install packages on macOS with Homebrew
# ==========================================

set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

# Load utilities
. "$SCRIPT_DIR/../lib/utils.sh"

# Load unified package manager
. "$SCRIPT_DIR/../lib/package_manager.sh"

# Install packages
install_packages "macos"
