#!/bin/sh
# ==========================================
# src/lib/helpers.sh
# Additional helper functions
# ==========================================
#
# Fonctions :
# - ensure_directory()   : Crée dossier si absent
# - backup_file()          : Backup avant modification
# - safe_link()            : Crée lien avec vérification
#

# Crée un dossier s'il n'existe pas
ensure_directory() {
    local dir="$1"
    if [ ! -d "$dir" ]; then
        mkdir -p "$dir"
        print_success "Directory created: $dir"
        return 0
    else
        return 0
    fi
}

# Crée un backup d'un fichier avant modification
backup_file() {
    local file="$1"
    if [ -f "$file" ]; then
        local backup="${file}.backup.$(date +%Y%m%d-%H%M%S)"
        cp "$file" "$backup"
        print_info "Backup created: $backup"
        echo "$backup"
        return 0
    else
        return 1
    fi
}

# Crée un lien symbolique avec vérification
safe_link() {
    local target="$1"
    local link_name="$2"
    
    # Backup si lien existant et différent
    if [ -L "$link_name" ]; then
        local current_target=$(readlink "$link_name")
        if [ "$current_target" != "$target" ]; then
            backup_file "$link_name" >/dev/null 2>&1
            rm "$link_name"
        else
            print_info "Link already exists: $link_name"
            return 0
        fi
    elif [ -e "$link_name" ]; then
        backup_file "$link_name" >/dev/null 2>&1
        rm -rf "$link_name"
    fi
    
    # Créer le lien
    if ln -sfn "$target" "$link_name"; then
        print_success "Link created: $link_name -> $target"
        return 0
    else
        print_error "Failed to create link: $link_name"
        return 1
    fi
}
