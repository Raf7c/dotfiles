#!/bin/sh
# ==========================================
# ~/install/fedora/packages.sh
# Install packages on Fedora with DNF
# ==========================================

set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
PACKAGES_DIR="$SCRIPT_DIR/../packages"

# Load unified package installer
. "$SCRIPT_DIR/../lib/install_packages.sh"

# Install packages
install_packages "fedora" "$PACKAGES_DIR"
