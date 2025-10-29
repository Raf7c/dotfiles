#!/bin/sh
# ==========================================
# ~/install/macOS/homebrew.sh
# Install and configure Homebrew
# ==========================================

set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

# Load utilities
. "$SCRIPT_DIR/../lib/utils.sh"

echo "🍺 Configuring Homebrew..."

# Check if Homebrew is installed
if command -v brew >/dev/null 2>&1; then
    print_success "Homebrew already installed: $(brew --version | head -n1)"
# Check Apple Silicon path
elif [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
    print_success "Homebrew found: $(brew --version | head -n1)"
# Check Intel path
elif [ -x /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv)"
    print_success "Homebrew found: $(brew --version | head -n1)"
# Install Homebrew
else
    echo "⬇️  Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Initialize after installation
    if [ -x /opt/homebrew/bin/brew ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [ -x /usr/local/bin/brew ]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
    
    print_success "Homebrew installed: $(brew --version | head -n1)"
fi

