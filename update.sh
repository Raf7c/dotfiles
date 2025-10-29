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

# Update package manager
case "$OS" in
    macos)
        echo "🍎 Updating macOS packages..."
        if command_exists brew; then
            echo "🍺 Updating Homebrew..."
            brew update
            brew upgrade
            brew cleanup
            print_success "Homebrew updated successfully"
            
            echo "🔧 Refreshing GCC cache..."
            sh "$SCRIPT_DIR/install/macOS/refresh-gcc-cache.sh" || print_warning "GCC cache refresh failed"
        else
            print_warning "Homebrew not found, skipping"
        fi
        ;;
    
    fedora)
        echo "🎩 Updating Fedora packages..."
        echo "🔄 Updating system packages..."
        sudo dnf update -y
        sudo dnf autoremove -y
        print_success "Fedora packages updated successfully"
        ;;
    
    arch)
        echo "🏔️  Updating Arch packages..."
        echo "🔄 Updating system packages..."
        sudo pacman -Syu --noconfirm
        sudo pacman -Sc --noconfirm 2>/dev/null || true
        
        if command_exists yay; then
            echo "📦 Updating AUR packages..."
            yay -Syu --noconfirm
        fi
        print_success "Arch packages updated successfully"
        ;;
esac
echo ""

# Update asdf plugins
if command_exists asdf; then
    echo "📦 Updating asdf plugins..."
    asdf plugin update --all || print_warning "asdf plugin update failed"
    print_success "asdf plugins updated successfully"
else
    print_warning "asdf not found, skipping"
fi
echo ""

# Update Zinit/Zsh plugins
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
echo ""

# Update tmux plugins
if command_exists tmux; then
    echo "🖥️  Updating tmux plugins..."
    if [ -d "$HOME/.config/tmux/plugins/tpm" ]; then
        "$HOME/.config/tmux/plugins/tpm/bin/update_plugins" all || print_warning "tmux plugin update failed"
        print_success "tmux plugins updated successfully"
    else
        print_warning "TPM not found, skipping tmux plugin update"
    fi
else
    print_warning "tmux not found, skipping"
fi
echo ""

# Update Cargo packages (if Rust is installed)
if command_exists cargo; then
    echo "🦀 Updating Cargo packages..."
    if command_exists cargo-install-update; then
        cargo install-update -a
        print_success "Cargo packages updated successfully"
    else
        print_info "Install cargo-update for automatic updates: cargo install cargo-update"
    fi
    echo ""
fi

# Summary
echo "========================================="
echo "🎉 Update completed!"
echo "🖥️  Platform: $OS"
echo "⏱️  Total time: $(format_duration $START_TIME)"
print_info "Consider running: ./test.sh to validate"
echo "========================================="

