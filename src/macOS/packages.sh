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
# For macOS, packages_dir is used to find Brewfile relative path
install_packages "macos" "$SCRIPT_DIR"
