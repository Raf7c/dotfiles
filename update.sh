#!/bin/bash
# ==========================================
# ~/update.sh
# Update environment
# ==========================================

set -eu

# Configuration
SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
START_TIME=$(date +%s)

# Load utilities
. "$SCRIPT_DIR/install/lib/utils.sh"

echo "🚀 macOS Environment Update"
echo "📅 Started at: $(date '+%Y-%m-%d %H:%M:%S')"
echo ""

# Verify macOS
check_macos || exit 1

# 1. Homebrew
if command_exists brew; then
    echo "🍺 Updating Homebrew..."
    brew update
    brew upgrade
    brew cleanup
    print_success "Homebrew updated successfully"

    echo "🔧 Refreshing GCC cache..."
    sh "$SCRIPT_DIR/install/macOS/refresh-gcc-cache.sh"
else
    print_warning "Homebrew not found, skipping Homebrew updates"
fi

# 2. Zinit
if command_exists zsh; then
    echo "🐚 Updating Zsh plugins..."
    if zsh -i -c "zinit self-update && zinit update" 2>/dev/null; then
        print_success "Zinit plugins updated successfully"
    else
        print_warning "Zinit not available or update failed"
    fi
else
    print_warning "zsh not found, skipping plugin update"
fi

# Summary
echo "========================================="
echo "🎉 Update completed!"
echo "⏱️  Total time: $(format_duration $START_TIME)"
echo "========================================="

