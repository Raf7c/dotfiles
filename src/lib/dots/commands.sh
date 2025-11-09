#!/bin/sh

DOTS_ROOT=${DOTS_ROOT:-$HOME/.dotfiles}
VALIDATE_MODULE="$DOTS_ROOT/src/lib/dots/validate.sh"
if [ -f "$VALIDATE_MODULE" ]; then
    . "$VALIDATE_MODULE"
fi

cmd_update() {
    os=$(detect_os)
    case "$os" in
        Windows)
            log_error "Update impossible sur Windows"
            return 1
            ;;
        Linux)
            log_error "Update non disponible sur Linux pour le moment"
            return 1
            ;;
        Unknown)
            log_error "Système d'exploitation inconnu : $(uname -s 2>/dev/null || echo inconnu)"
            return 1
            ;;
    esac

    print_os_info "$os"

    input_mode="${1:-}"
    mode=""

    if [ -n "$input_mode" ]; then
        case "$input_mode" in
            setup_minimale|setup_complet)
                mode="$input_mode"
                ;;
            *)
                log_error "Mode inconnu pour update : $input_mode"
                return 1
                ;;
        esac
    else
        if command -v resolve_mode >/dev/null 2>&1; then
            mode="$(resolve_mode "")"
        else
            mode="setup_complet"
        fi
    fi

    if [ "$os" = "macOS" ] && [ "$mode" = "setup_complet" ]; then
        brewfile="$DOTS_ROOT/Brewfile"
        if [ ! -f "$brewfile" ]; then
            log_error "Brewfile introuvable : $brewfile"
            return 1
        fi
        if ! command -v brew >/dev/null 2>&1; then
            log_error "Homebrew n'est pas installé"
            return 1
        fi

        log_info "Mise à jour des paquets Homebrew selon $brewfile"
        if ! run_step "brew bundle (install)" brew bundle --file="$brewfile"; then
            return 1
        fi
        if ! run_step "brew bundle cleanup" brew bundle cleanup --file="$brewfile" --force; then
            return 1
        fi
        log_success "Paquets Homebrew synchronisés avec Brewfile"
    else
        log_info "Aucune mise à jour spécifique pour le mode $mode sur $os"
    fi

    log_success "Update terminé"
}

cmd_check() {
    input_mode="${1:-}"
    if ! command -v validate_links >/dev/null 2>&1; then
        log_error "Module de validation indisponible"
        return 1
    fi
    validate_links "$input_mode"
}

