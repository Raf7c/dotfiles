#!/bin/bash
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

# Generic update function
update_tool() {
    local tool="$1"
    local emoji="$2"
    local description="$3"
    shift 3
    local update_cmd="$@"
    
    if command_exists "$tool"; then
        echo "$emoji Updating $description..."
        if eval "$update_cmd"; then
            print_success "$description updated successfully"
        else
            print_warning "$description update failed"
        fi
    else
        print_warning "$tool not found, skipping $description"
    fi
    echo ""
}

# Update package manager
case "$OS" in
    macos)
        echo "🍎 Updating macOS packages..."
        update_tool "brew" "🍺" "Homebrew" "brew update && brew upgrade && brew cleanup"
        
        if [ -f "$SCRIPT_DIR/install/macOS/refresh-gcc-cache.sh" ]; then
            echo "🔧 Refreshing GCC cache..."
            sh "$SCRIPT_DIR/install/macOS/refresh-gcc-cache.sh" || print_warning "GCC cache refresh failed"
            echo ""
        fi
        ;;
    
    fedora)
        echo "🎩 Updating Fedora packages..."
        echo "🔄 Updating system packages..."
        if sudo dnf update -y; then
            sudo dnf autoremove -y
            print_success "Fedora packages updated successfully"
        else
            print_warning "Fedora update failed"
        fi
        echo ""
        ;;
    
    arch)
        echo "🏔️  Updating Arch packages..."
        echo "🔄 Updating system packages..."
        if sudo pacman -Syu --noconfirm; then
            sudo pacman -Sc --noconfirm 2>/dev/null || true
            print_success "Arch packages updated successfully"
        else
            print_warning "Arch update failed"
        fi
        echo ""
        
        update_tool "yay" "📦" "AUR packages" "yay -Syu --noconfirm"
        ;;
esac

# Update common tools
update_tool "asdf" "📦" "asdf plugins" "asdf plugin update --all"

update_tool "zsh" "🐚" "Zsh plugins" "zsh -i -c 'zinit self-update && zinit update' 2>/dev/null"

if command_exists tmux && [ -d "$HOME/.config/tmux/plugins/tpm" ]; then
    update_tool "tmux" "🖥️" "tmux plugins" "'$HOME/.config/tmux/plugins/tpm/bin/update_plugins' all"
fi

if command_exists cargo; then
    update_tool "cargo-install-update" "🦀" "Cargo packages" "cargo install-update -a"
    
    if ! command_exists cargo-install-update; then
        print_info "Install cargo-update for automatic updates: cargo install cargo-update"
        echo ""
    fi
fi

# Summary
echo "========================================="
echo "🎉 Update completed!"
echo "🖥️  Platform: $OS"
echo "⏱️  Total time: $(format_duration $START_TIME)"
print_info "Consider running: ./test.sh to validate"
echo "========================================="
