#!/bin/sh
# ==========================================
# src/lib/git.sh
# Git operations and submodules management
# ==========================================
#
# Fonctions :
# - init_submodules()     : Initialise les sous-modules
# - update_submodules()   : Met à jour les sous-modules
# - check_submodules()    : Vérifie si sous-modules existent
#

# Initialise les sous-modules Git (pour bootstrap.sh)
init_submodules() {
    local script_dir="${1:-${SCRIPT_DIR:-$HOME/.dotfiles}}"
    
    if [ ! -f "$script_dir/.gitmodules" ]; then
        print_info "No .gitmodules found, skipping submodules initialization"
        return 0
    fi
    
    print_step "Initializing git submodules"
    
    if (cd "$script_dir" && git submodule update --init --recursive); then
        print_success "Git submodules initialized"
        return 0
    else
        print_warning "Git submodules initialization failed"
        return 1
    fi
}

# Met à jour les sous-modules Git (pour update.sh)
update_submodules() {
    local script_dir="${1:-${SCRIPT_DIR:-$HOME/.dotfiles}}"
    
    if [ ! -f "$script_dir/.gitmodules" ]; then
        print_info "No .gitmodules found, skipping submodules update"
        return 0
    fi
    
    print_step "Updating git submodules"
    
    if (cd "$script_dir" && git submodule update --remote --merge); then
        print_success "Git submodules updated"
        return 0
    else
        print_warning "Git submodules update failed"
        return 1
    fi
}

# Vérifie si des sous-modules sont configurés
check_submodules() {
    local script_dir="${1:-${SCRIPT_DIR:-$HOME/.dotfiles}}"
    
    if [ -f "$script_dir/.gitmodules" ]; then
        return 0  # Sous-modules existent
    else
        return 1  # Pas de sous-modules
    fi
}

