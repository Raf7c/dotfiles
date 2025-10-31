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
. "$SCRIPT_DIR/install/lib/utils.sh"
. "$SCRIPT_DIR/install/lib/git.sh"

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
    if init_submodules "$SCRIPT_DIR"; then
        print_success "Git submodules initialized"
    else
        print_warning "Git submodules initialization failed, continuing..."
    fi
    echo ""
fi

run_step "Creating symbolic links" "$SCRIPT_DIR/install/common/link_global.sh" "critical"

# OS-specific package installation
case "$OS" in
    macos)
        run_step "Configuring Homebrew" "$SCRIPT_DIR/install/macOS/homebrew.sh" "critical"
        run_step "Installing packages" "$SCRIPT_DIR/install/macOS/packages.sh" "critical"
        ;;
    arch)
        run_step "Installing packages" "$SCRIPT_DIR/install/arch/packages.sh" "critical"
        ;;
esac

# Load shell environment
echo "📚 Configuring shell..."
if [ -f "$SCRIPT_DIR/.config/shell/env" ]; then
    . "$SCRIPT_DIR/.config/shell/env"
else
    print_warning "shell/env not found, skipping shell environment loading"
fi
echo ""

# Common steps
run_step "Shell migration" "$SCRIPT_DIR/install/common/shell.sh" "optional"

# Only if tmux is installed
if command_exists tmux; then
    run_step "Installing Tmux plugins" "$SCRIPT_DIR/install/common/tmux-tmp.sh" "optional"
fi

# Only if asdf is installed and .tool-versions exists
if command_exists asdf && [ -f "$SCRIPT_DIR/.tool-versions" ]; then
    run_step "Installing asdf plugins" "$SCRIPT_DIR/install/common/asdf-install.sh" "optional"
fi

# OS-specific configuration
case "$OS" in
    macos)
        run_step "Refreshing GCC cache" "$SCRIPT_DIR/install/macOS/refresh-gcc-cache.sh" "optional"
        run_step "Configuring macOS" "$SCRIPT_DIR/install/macOS/osx.sh" "optional"
        ;;
esac

# Summary
echo ""
echo "========================================="
echo "🎉 Configuration completed!"
echo "🖥️  Platform: $OS"
echo "⏱️  Total time: $(format_duration $START_TIME)"
echo "📝 Full log: $LOG_FILE"
print_info "Some changes may require a full restart."
echo "========================================="
