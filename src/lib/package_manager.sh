#!/bin/sh
# ==========================================
# src/lib/package_manager.sh
# Unified package manager operations
# ==========================================
#
# Fonctions :
# - install_packages()        : Installation packages depuis Brewfile (macOS) ou .txt (Arch)
# - update_packages_for_os()  : Mise à jour packages système
# - sync_brewfile()            : Synchronise Brewfile avec packages installés
#

# Installation packages depuis Brewfile (macOS) ou fichier .txt (Arch)
install_packages() {
    local os="$1"
    local pkg_file="${2:-}"  # Required for Arch, empty for macOS
    
    echo "📦 Installing packages..."
    
    # Configure commands once based on OS
    case "$os" in
        macos)
            # Use Brewfile directly from dotfiles root
            if ! command -v brew >/dev/null 2>&1; then
                print_error "Homebrew not available"
                return 1
            fi
            echo "🍎 Installing macOS packages..."
            
            local brewfile="${DOTFILES:-$HOME/.dotfiles}/Brewfile"
            if [ ! -f "$brewfile" ]; then
                print_error "Brewfile not found: $brewfile"
                print_info "Create a Brewfile or run: brew bundle dump --file=$brewfile"
                return 1
            fi
            
            echo "📦 Using Brewfile: $brewfile"
            if brew bundle install --file="$brewfile"; then
                brew cleanup -q 2>/dev/null || true
                print_success "Installation complete! (Brewfile processed)"
                return 0
            else
                print_warning "Brewfile installation had warnings"
                brew cleanup -q 2>/dev/null || true
                return 1
            fi
            ;;
        arch)
            if [ ! -f "$pkg_file" ]; then
                print_error "Package file not found: $pkg_file"
                return 1
            fi
            
            echo "🔄 Updating system..."
            sudo pacman -Syu --noconfirm
            echo "🏔️  Installing Arch packages..."
            install_cmd="sudo pacman -S --noconfirm --needed"
            cleanup_cmd="sudo pacman -Sc --noconfirm"
            
            # Install packages
            installed=0
            skipped=0
            
            while IFS= read -r pkg || [ -n "$pkg" ]; do
                # Skip empty lines and comments
                [ -z "$pkg" ] && continue
                case "$pkg" in \#*) continue ;; esac
                
                if $install_cmd "$pkg" 2>/dev/null; then
                    printf "  " && print_success "$pkg"
                    installed=$((installed + 1))
                else
                    printf "  " && print_warning "$pkg (skipped)"
                    skipped=$((skipped + 1))
                fi
            done < "$pkg_file" || true
            
            # Cleanup
            $cleanup_cmd 2>/dev/null || true
            
            # Summary
            echo ""
            if [ $skipped -eq 0 ]; then
                print_success "Installation complete! ($installed packages installed)"
            else
                print_warning "Installation complete with warnings ($installed installed, $skipped skipped)"
            fi
            ;;
        *)
            print_error "Unsupported OS: $os"
            return 1
            ;;
    esac
    return 0
}

# Mise à jour packages système (pour update.sh) - uniquement packages listés
update_packages_for_os() {
    local os="$1"
    
    case "$os" in
        macos)
            echo "🍎 Updating macOS packages..."
            # Update Homebrew
            if brew update; then
                # Upgrade packages from Brewfile (brew bundle automatically upgrades)
                local brewfile="${DOTFILES:-$HOME/.dotfiles}/Brewfile"
                if [ -f "$brewfile" ]; then
                    echo "📦 Upgrading packages from Brewfile..."
                    # brew bundle install automatically upgrades packages listed in Brewfile
                    if brew bundle install --file="$brewfile" 2>/dev/null; then
                        brew cleanup -q 2>/dev/null || true
                        print_success "macOS packages updated successfully (Brewfile packages only)"
                        return 0
                    else
                        print_warning "Brewfile installation/upgrade had warnings"
                        brew cleanup -q 2>/dev/null || true
                        return 1
                    fi
                else
                    print_warning "Brewfile not found, skipping package updates"
                    brew cleanup -q 2>/dev/null || true
                    return 1
                fi
            else
                print_warning "macOS update failed"
                return 1
            fi
            ;;
        arch)
            echo "🏔️  Updating Arch packages..."
            
            # First update system
            echo "🔄 Updating system..."
            if sudo pacman -Sy --noconfirm; then
                # Read arch.txt and update only listed packages
                local arch_file="${DOTFILES:-$HOME/.dotfiles}/src/arch/arch.txt"
                if [ -f "$arch_file" ]; then
                    echo "📦 Updating packages from arch.txt only..."
                    local packages_to_update=""
                    
                    while IFS= read -r pkg || [ -n "$pkg" ]; do
                        # Skip empty lines and comments
                        [ -z "$pkg" ] && continue
                        case "$pkg" in \#*) continue ;; esac
                        
                        # Check if package is installed
                        if pacman -Qi "$pkg" >/dev/null 2>&1; then
                            if [ -z "$packages_to_update" ]; then
                                packages_to_update="$pkg"
                            else
                                packages_to_update="$packages_to_update $pkg"
                            fi
                        fi
                    done < "$arch_file"
                    
                    # Update only packages from the list that are installed
                    if [ -n "$packages_to_update" ]; then
                        sudo pacman -Su --noconfirm $packages_to_update || true
                    fi
                else
                    print_warning "arch.txt not found: $arch_file"
                fi
                
                # Cleanup
                sudo pacman -Sc --noconfirm 2>/dev/null || true
                print_success "Arch packages updated successfully (arch.txt packages only)"
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

# Synchronise le Brewfile avec les packages actuellement installés
sync_brewfile() {
    local brewfile="${1:-${DOTFILES:-$HOME/.dotfiles}/Brewfile}"
    
    if ! command -v brew >/dev/null 2>&1; then
        print_warning "Homebrew not available, skipping Brewfile sync"
        return 1
    fi
    
    if [ ! -f "$brewfile" ]; then
        print_info "Brewfile not found, creating: $brewfile"
        mkdir -p "$(dirname "$brewfile")"
    fi
    
    echo "🔄 Syncing Brewfile with installed packages..."
    if brew bundle dump --file="$brewfile" --force 2>/dev/null; then
        print_success "Brewfile synced successfully: $brewfile"
        return 0
    else
        print_warning "Brewfile sync failed"
        return 1
    fi
}

