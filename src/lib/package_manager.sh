#!/bin/sh
# ==========================================
# src/lib/package_manager.sh
# Unified package manager operations
# ==========================================
#
# Fonctions :
# - install_packages()        : Installation packages depuis Brewfile (macOS)
# - update_packages_for_os()  : Mise à jour packages système
# - sync_brewfile()            : Synchronise Brewfile avec packages installés
#

# Installation packages depuis Brewfile (macOS)
install_packages() {
    local os="$1"
    
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

