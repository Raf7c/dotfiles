#!/bin/sh
# ==========================================
# install/lib/package_manager.sh
# Unified package manager operations
# ==========================================
#
# Fonctions :
# - install_packages()        : Installation packages depuis .txt
# - update_packages_for_os()  : Mise à jour packages système
# - get_package_manager()     : Retourne gestionnaire pour OS
# - get_cleanup_cmd()         : Retourne commande nettoyage
#

# Installation packages depuis fichier .txt
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

# Mise à jour packages système (pour update.sh)
update_packages_for_os() {
    local os="$1"
    
    case "$os" in
        macos)
            echo "🍎 Updating macOS packages..."
            if brew update && brew upgrade && brew cleanup; then
                print_success "macOS packages updated successfully"
                return 0
            else
                print_warning "macOS update failed"
                return 1
            fi
            ;;
        arch)
            echo "🏔️  Updating Arch packages..."
            echo "🔄 Updating system packages..."
            if sudo pacman -Syu --noconfirm; then
                sudo pacman -Sc --noconfirm 2>/dev/null || true
                print_success "Arch packages updated successfully"
                
                # Update AUR packages if yay is installed
                if command -v yay >/dev/null 2>&1; then
                    echo "📦 Updating AUR packages..."
                    if yay -Syu --noconfirm; then
                        print_success "AUR packages updated successfully"
                    else
                        print_warning "AUR update failed"
                    fi
                fi
                echo ""
                return 0
            else
                print_warning "Arch update failed"
                return 1
            fi
            ;;
        *)
            print_error "Unsupported OS: $os"
            return 1
            ;;
    esac
}

# Retourne le nom du gestionnaire de paquets pour l'OS
get_package_manager() {
    local os="$1"
    case "$os" in
        macos) echo "brew" ;;
        arch) echo "pacman" ;;
        *) echo "unknown" ;;
    esac
}

# Retourne la commande de nettoyage pour l'OS
get_cleanup_cmd() {
    local os="$1"
    case "$os" in
        macos) echo "brew cleanup -q" ;;
        arch) echo "sudo pacman -Sc --noconfirm" ;;
        *) echo "" ;;
    esac
}

