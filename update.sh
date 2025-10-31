#!/bin/sh
# ==========================================
# ~/update.sh
# Cross-platform environment update
# ==========================================

set -eu

# Configuration
SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
START_TIME=$(date +%s)

# Load utilities
. "$SCRIPT_DIR/install/lib/utils.sh"
. "$SCRIPT_DIR/install/lib/package_manager.sh"
. "$SCRIPT_DIR/install/lib/git.sh"

# Detect OS
OS=$(detect_os)

echo "========================================="
echo "🚀 Dotfiles Environment Update"
echo "🖥️  System: $OS"
echo "📅 Started at: $(date '+%Y-%m-%d %H:%M:%S')"
echo "========================================="
echo ""

# Check OS support
check_os_support || exit 1
echo ""

# Update package manager (utilise module package_manager.sh)
echo ""
update_packages_for_os "$OS"

# Refresh GCC cache on macOS
if [ "$OS" = "macos" ] && [ -f "$SCRIPT_DIR/install/macOS/refresh-gcc-cache.sh" ]; then
    echo "🔧 Refreshing GCC cache..."
    sh "$SCRIPT_DIR/install/macOS/refresh-gcc-cache.sh" || print_warning "GCC cache refresh failed"
    echo ""
fi

# Update git submodules
if check_submodules "$SCRIPT_DIR"; then
    echo ""
    update_submodules "$SCRIPT_DIR"
fi

# Update common tools (utilise update_tool depuis utils.sh)
update_tool "asdf" "📦" "asdf plugins" "asdf plugin update --all"
update_tool "zsh" "🐚" "Zsh plugins" "zsh -i -c 'zinit self-update && zinit update' 2>/dev/null"

# Update Tmux plugins (if TPM exists)
if command_exists tmux && [ -d "$HOME/.config/tmux/plugins/tpm" ]; then
    update_tool "tmux" "🖥️" "tmux plugins" "'$HOME/.config/tmux/plugins/tpm/bin/update_plugins' all"
fi

# Summary
echo "========================================="
echo "🎉 Update completed!"
echo "🖥️  Platform: $OS"
echo "⏱️  Total time: $(format_duration $START_TIME)"
print_info "Consider running: ./test.sh to validate"
echo "========================================="
