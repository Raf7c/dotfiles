#!/bin/sh

set -eu

DOTS_ROOT=${DOTS_ROOT:-$HOME/.dotfiles}
LOG_INIT="$DOTS_ROOT/src/lib/dots/log_init.sh"
if [ -f "$LOG_INIT" ]; then
    . "$LOG_INIT"
else
    log_info() { printf 'ℹ️  %s\n' "$*"; }
    log_error() { printf '❌ %s\n' "$*" >&2; }
    log_success() { printf '✅ %s\n' "$*"; }
fi

SPEC_FILE="$DOTS_ROOT/src/setup/link_specs.sh"
if [ ! -f "$SPEC_FILE" ]; then
    log_error "Fichier de spécification manquant : $SPEC_FILE"
    exit 1
fi
. "$SPEC_FILE"

mode="${1:-setup_complet}"

if [ ! -d "$DOTS_ROOT" ]; then
    log_error "Répertoire dotfiles introuvable : $DOTS_ROOT"
    exit 1
fi

log_info "🔗 Création des liens ($mode)"

create_link() {
    src="$DOTS_ROOT/$1"
    dest="$HOME/$2"

    if [ ! -e "$src" ] && [ ! -L "$src" ]; then
        log_error "Source absente : $src"
        return 1
    fi

    mkdir -p "$(dirname "$dest")"
    if [ -L "$dest" ]; then
        current_target=$(readlink "$dest" 2>/dev/null || echo "")
        if [ "$current_target" = "$src" ]; then
            log_info "Lien déjà en place : $dest -> $src"
            return 0
        fi
    fi

    rm -rf "$dest"

    if ln -s "$src" "$dest"; then
        log_success "Lien créé : $dest -> $src"
    else
        log_error "Échec du lien : $dest -> $src"
        return 1
    fi
}

apply_links() {
    spec_func="$1"
    status=0
    while IFS=":" read -r src dest || [ -n "$src" ]; do
        [ -z "$src" ] && continue
        if ! create_link "$src" "$dest"; then
            status=1
        fi
    done <<EOF
$($spec_func)
EOF
    return $status
}

setup_minimale() {
    apply_links setup_links_minimale || return 1
    log_success "Setup minimale terminé"
}

setup_complet() {
    apply_links setup_links_complet || return 1
    log_success "Setup complet terminé"
}

case "$mode" in
    setup_minimale)
        setup_minimale
        ;;
    setup_complet)
        setup_complet
        ;;
    *)
        log_error "Mode inconnu : $mode"
        echo "Utilisation : sh link_global.sh [setup_minimale|setup_complet]" >&2
        exit 1
        ;;
esac
