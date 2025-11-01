#!/bin/sh
# ==========================================
# ~/bootstrap.sh
# Cross-platform Dotfiles Installation
# ==========================================

set -eu

# Configuration
SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
LOG_FILE="$HOME/.dotfiles/install.log"
START_TIME=$(date +%s)

# Load utilities
. "$SCRIPT_DIR/src/lib/utils.sh"
. "$SCRIPT_DIR/src/lib/git.sh"

# Setup logging with tee (sh-compatible)
if [ "${BOOTSTRAP_LOGGING:-}" != "active" ]; then
    export BOOTSTRAP_LOGGING="active"
    "$0" "$@" 2>&1 | tee "$LOG_FILE"
    exit $?
fi

# Detect OS
OS=$(detect_os)

echo "========================================="
echo "🚀 Dotfiles Configuration"
echo "🖥️  System: $OS"
echo "📝 Logging to: $LOG_FILE"
echo "📅 Started at: $(date '+%Y-%m-%d %H:%M:%S')"
echo "========================================="
echo ""

# Check OS support
check_os_support || exit 1
echo ""

# Check requirements
check_requirements git curl || exit 1

# Common steps for all platforms
echo "📦 Common installation steps..."

# Initialize git submodules (e.g., Neovim config)
if check_submodules "$SCRIPT_DIR"; then
    print_step "Initializing git submodules"
    init_submodules "$SCRIPT_DIR" || print_warning "Git submodules initialization failed, continuing..."
    echo ""
fi

run_step "Creating symbolic links" "$SCRIPT_DIR/src/common/setup/link_global.sh" "critical"

# OS-specific package installation
# Configure Homebrew on macOS (required before package installation)
if [ "$OS" = "macos" ]; then
    run_step "Configuring Homebrew" "$SCRIPT_DIR/src/macOS/homebrew.sh" "critical"
fi

# Install packages (unified for all OS)
run_step "Installing packages" "$SCRIPT_DIR/src/${OS}/packages.sh" "critical"

# Load shell environment
echo "📚 Configuring shell..."
if [ -f "$SCRIPT_DIR/.config/shell/env" ]; then
    . "$SCRIPT_DIR/.config/shell/env"
fi
echo ""

# Common steps
run_step "Shell migration" "$SCRIPT_DIR/src/common/shell/shell.sh" "optional"

# Install optional tools (only if prerequisites exist)
run_if_exists "tmux" "Installing Tmux plugins" "$SCRIPT_DIR/src/common/tools/tmux.sh" "optional"
run_if_exists_and_file "asdf" "$SCRIPT_DIR/.tool-versions" "Installing asdf plugins" "$SCRIPT_DIR/src/common/tools/asdf.sh" "optional"

# OS-specific configuration
if [ "$OS" = "macos" ]; then
    run_step "Refreshing GCC cache" "$SCRIPT_DIR/src/macOS/refresh-gcc-cache.sh" "optional"
    run_step "Configuring macOS" "$SCRIPT_DIR/src/macOS/osx.sh" "optional"
fi

# Summary
echo ""
echo "========================================="
echo "🎉 Configuration completed!"
echo "🖥️  Platform: $OS"
echo "⏱️  Total time: $(format_duration $START_TIME)"
echo "📝 Full log: $LOG_FILE"
print_info "Some changes may require a full restart."
echo "========================================="
