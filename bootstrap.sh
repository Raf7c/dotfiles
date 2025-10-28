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

# Redirect output to log file AND terminal
exec > >(tee -a "$LOG_FILE")
exec 2>&1

echo "========================================="
echo "🚀 macOS Environment Configuration"
echo "📝 Logging to: $LOG_FILE"
echo "📅 Started at: $(date '+%Y-%m-%d %H:%M:%S')"
echo "========================================="
echo ""

# macOS verification
if [ "$(uname -s)" != "Darwin" ]; then
    printf '%s\n' "❌ This script must be run on macOS" >&2
    exit 1
fi

# Check requirements
echo "🔍 Checking requirements..."
missing_requirements=0
for cmd in git curl; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "❌ Required command not found: $cmd"
        missing_requirements=1
    else
        echo "✅ $cmd: $(command -v $cmd)"
    fi
done

if [ "$missing_requirements" -eq 1 ]; then
    echo ""
    echo "💡 To install missing tools on macOS:"
    echo "   xcode-select --install"
    exit 1
fi
echo "✅ All requirements met"
echo ""

# Helper function to run installation steps
run_step() {
    step_name="$1"
    script_path="$2"
    critical="${3:-optional}"
    
    echo "▶️  $step_name"
    
    if sh "$script_path"; then
        echo "✅ $step_name completed"
        return 0
    else
        exit_code=$?
        echo "❌ $step_name failed (exit code: $exit_code)"
        
        if [ "$critical" = "critical" ]; then
            echo "⚠️  Critical step failed, aborting..."
            exit 1
        else
            echo "⚠️  Non-critical step, continuing..."
            return 1
        fi
    fi
    echo ""
}

# Sequential execution
run_step "Creating symbolic links" "$SCRIPT_DIR/install/link_global.sh" "critical"
run_step "Configuring Homebrew" "$SCRIPT_DIR/install/macOS/homebrew.sh" "critical"
run_step "Generating GCC cache" "$SCRIPT_DIR/install/macOS/refresh-gcc-cache.sh" "optional"

echo "📚 Configuring shell..."
# Source shell environment if available
if [ -f "$SCRIPT_DIR/.config/shell/env" ]; then
    . "$SCRIPT_DIR/.config/shell/env"
else
    echo "⚠️ shell/env not found, skipping shell environment loading"
fi
echo ""

run_step "Shell migration" "$SCRIPT_DIR/install/shell.sh" "optional"
run_step "Installing Tmux plugins" "$SCRIPT_DIR/install/tmux-tmp.sh" "optional"
run_step "Configuring macOS" "$SCRIPT_DIR/install/macOS/osx.sh" "optional"
run_step "Installing asdf plugins" "$SCRIPT_DIR/install/asdf-install.sh" "optional"

# Calculate duration
END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))
MINUTES=$((DURATION / 60))
SECONDS=$((DURATION % 60))

# Summary
echo "========================================="
echo "🎉 Configuration completed!"
echo "⏱️  Total time: ${MINUTES}m ${SECONDS}s"
echo "📝 Full log: $LOG_FILE"
echo "💡 Some changes may require a full restart."
echo "========================================="
