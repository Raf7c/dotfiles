#!/bin/bash
# ==========================================
# ~/bootstrap.sh
# Dotfiles Installation
# ==========================================

set -eu

# Configuration
SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
LOG_FILE="$HOME/.dotfiles/install.log"
START_TIME=$(date +%s)

# Load utilities
. "$SCRIPT_DIR/install/lib/utils.sh"

# Setup logging
setup_logging "$LOG_FILE"

echo "========================================="
echo "🚀 macOS Environment Configuration"
echo "📝 Logging to: $LOG_FILE"
echo "📅 Started at: $(date '+%Y-%m-%d %H:%M:%S')"
echo "========================================="
echo ""

# Verify macOS
check_macos || exit 1

# Check requirements
check_requirements git curl || exit 1

# Sequential execution
run_step "Creating symbolic links" "$SCRIPT_DIR/install/link_global.sh" "critical"
run_step "Configuring Homebrew" "$SCRIPT_DIR/install/macOS/homebrew.sh" "critical"
run_step "Generating GCC cache" "$SCRIPT_DIR/install/macOS/refresh-gcc-cache.sh" "optional"

echo "📚 Configuring shell..."
if [ -f "$SCRIPT_DIR/.config/shell/env" ]; then
    . "$SCRIPT_DIR/.config/shell/env"
else
    print_warning "shell/env not found, skipping shell environment loading"
fi
echo ""

run_step "Shell migration" "$SCRIPT_DIR/install/shell.sh" "optional"
run_step "Installing Tmux plugins" "$SCRIPT_DIR/install/tmux-tmp.sh" "optional"
run_step "Configuring macOS" "$SCRIPT_DIR/install/macOS/osx.sh" "optional"
run_step "Installing asdf plugins" "$SCRIPT_DIR/install/asdf-install.sh" "optional"

# Summary
echo "========================================="
echo "🎉 Configuration completed!"
echo "⏱️  Total time: $(format_duration $START_TIME)"
echo "📝 Full log: $LOG_FILE"
print_info "Some changes may require a full restart."
echo "========================================="
