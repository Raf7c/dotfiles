#!/bin/sh

DOTS_ROOT=${DOTS_ROOT:-$HOME/.dotfiles}
SPEC_FILE="$DOTS_ROOT/src/setup/link_specs.sh"
if [ ! -f "$SPEC_FILE" ]; then
    log_error "Fichier de spécification manquant : $SPEC_FILE"
    return 1 2>/dev/null || exit 1
fi
. "$SPEC_FILE"

MODE_FILE="$DOTS_ROOT/.cache/dots_install_mode"

validate_shell_migration() {
    state_root=${XDG_STATE_HOME:-$HOME/.local/state}
    status=0

    log_info "Validation de la migration des historiques shell"

    for shell in zsh bash; do
        history_file="$state_root/$shell/history"
        if [ -f "$history_file" ]; then
            log_success "Historique $shell OK : $history_file"
        else
            log_error "Historique $shell absent : $history_file"
            status=1
        fi
    done

    for cache_dir in "$HOME/.cache/zsh" "$HOME/.cache/bash"; do
        if [ -d "$cache_dir" ]; then
            log_success "Cache OK : $cache_dir"
        else
            log_error "Cache manquant : $cache_dir"
            status=1
        fi
    done

    [ "$status" -eq 0 ] && log_success "Migration des shells validée"
    return $status
}

validate_gcc_cache() {
    cache_file="$HOME/.cache/gcc_aliases"
    if [ ! -f "$cache_file" ]; then
        log_error "Cache GCC absent : $cache_file"
        return 1
    fi

    status=0
    for entry in gcc g++; do
        alias_path=$(grep "^alias $entry=" "$cache_file" | sed "s/^alias $entry=\"//; s/\"$//")
        if [ -n "$alias_path" ] && [ -x "$alias_path" ]; then
            log_success "Alias $entry valide -> $alias_path"
        else
            log_error "Alias $entry invalide dans $cache_file"
            status=1
        fi
    done

    [ "$status" -eq 0 ] && log_success "Cache GCC valide : $cache_file"
    return $status
}

resolve_mode() {
    requested="$1"
    if [ -n "$requested" ]; then
        printf '%s' "$requested"
        return
    fi
    if [ -f "$MODE_FILE" ]; then
        cat "$MODE_FILE"
    else
        printf 'setup_complet'
    fi
}

validate_links() {
    requested_mode="$1"
    mode="$(resolve_mode "$requested_mode")"
    missing=0
    bad_links=0

    case "$mode" in
        setup_minimale)
            entries=$(setup_links_minimale)
            ;;
        setup_complet)
            entries=$(setup_links_complet)
            ;;
        *)
            log_error "Mode de validation inconnu : $mode"
            return 1
            ;;
    esac

    log_info "Validation des liens ($mode)"

    while IFS=":" read -r src dest || [ -n "$src" ]; do
        [ -z "$src" ] && continue
        abs_src="$DOTS_ROOT/$src"
        abs_dest="$HOME/$dest"

        if [ ! -e "$abs_src" ] && [ ! -L "$abs_src" ]; then
            log_error "Source manquante : $abs_src"
            missing=$((missing + 1))
            continue
        fi

        if [ ! -L "$abs_dest" ]; then
            log_error "Lien absent : $abs_dest"
            bad_links=$((bad_links + 1))
            continue
        fi

        current_target=$(readlink "$abs_dest" 2>/dev/null || echo "")
        if [ "$current_target" = "$abs_src" ]; then
            log_success "Lien valide : $abs_dest"
        else
            log_error "Lien invalide : $abs_dest -> $current_target (attendu : $abs_src)"
            bad_links=$((bad_links + 1))
        fi
    done <<EOF
$entries
EOF

    if [ "$missing" -gt 0 ] || [ "$bad_links" -gt 0 ]; then
        log_error "Validation échouée ($mode) : sources manquantes=$missing, liens incorrects=$bad_links"
        return 1
    fi

    if ! validate_shell_migration; then
        return 1
    fi

    os="$(detect_os)"
    if [ "$mode" = "setup_complet" ] && [ "$os" = "macOS" ]; then
        if command -v brew >/dev/null 2>&1; then
            brew_info=$(brew --version | head -n1)
            log_success "Homebrew détecté : $brew_info"
            if ! validate_gcc_cache; then
                return 1
            fi
        else
            log_error "Homebrew non détecté alors que setup_complet est installé"
            return 1
        fi
    fi

    log_success "Validation réussie ($mode)"
    return 0
}
