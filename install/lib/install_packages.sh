#!/bin/sh
# ==========================================
# install/lib/install_packages.sh
# Unified package installation for all OS
# ==========================================

install_packages() {
    local os="$1"
    local packages_dir="$2"
    local pkg_file="$packages_dir/${os}.txt"
    
    if [ ! -f "$pkg_file" ]; then
        print_error "Package file not found: $pkg_file"
        return 1
    fi
    
    echo "📦 Installing packages..."
    
    # Configure commands once based on OS
    case "$os" in
        macos)
            if ! command -v brew >/dev/null 2>&1; then
                print_error "Homebrew not available"
                return 1
            fi
            echo "🍎 Installing macOS packages..."
            install_cmd="brew install"
            cask_cmd="brew install --cask"
            cleanup_cmd="brew cleanup -q"
            ;;
        fedora)
            echo "🔄 Updating system..."
            sudo dnf update -y -q
            echo "📦 Installing Fedora packages..."
            install_cmd="sudo dnf install -y -q"
            cleanup_cmd="sudo dnf autoremove -y -q"
            ;;
        arch)
            echo "🔄 Updating system..."
            sudo pacman -Syu --noconfirm
            echo "🏔️  Installing Arch packages..."
            install_cmd="sudo pacman -S --noconfirm --needed"
            cleanup_cmd="sudo pacman -Sc --noconfirm"
            ;;
        *)
            print_error "Unsupported OS: $os"
            return 1
            ;;
    esac
    
    # Install packages
    while IFS= read -r pkg || [ -n "$pkg" ]; do
        # Skip empty lines and comments
        [ -z "$pkg" ] && continue
        case "$pkg" in \#*) continue ;; esac
        
        # Handle macOS casks
        if [ "$os" = "macos" ] && echo "$pkg" | grep -q "^cask:"; then
            pkg=$(echo "$pkg" | sed 's/^cask://')
            if $cask_cmd "$pkg" 2>/dev/null; then
                printf "  " && print_success "$pkg"
            else
                printf "  " && print_warning "$pkg (skipped)"
            fi
        else
            if $install_cmd "$pkg" 2>/dev/null; then
                printf "  " && print_success "$pkg"
            else
                printf "  " && print_warning "$pkg (skipped)"
            fi
        fi
    done < "$pkg_file" || true
    
    # Cleanup
    $cleanup_cmd 2>/dev/null || true
    
    print_success "Installation complete!"
    return 0
}
