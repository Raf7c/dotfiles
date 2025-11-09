#!/bin/sh

MAX_INSTALL_ATTEMPTS=${MAX_INSTALL_ATTEMPTS:-3}

prompt_install_choice() {
    cat <<'EOF'
Quelle installation souhaitez-vous ?
  1) setup minimale
  2) setup complet
EOF
    printf 'Votre choix: '
}

resolve_install_choice() {
    choice="$1"
    case "$choice" in
        1|"setup minimale")
            printf 'setup_minimale'
            ;;
        2|"setup complet")
            printf 'setup_complet'
            ;;
        *)
            return 1
            ;;
    esac
}

run_link_global_setup() {
    mode="$1"
    script_path="$DOTS_ROOT/src/setup/link_global.sh"

    if [ ! -f "$script_path" ]; then
        log_error "Script introuvable : $script_path"
        return 1
    fi

    run_step "link_global.sh ($mode)" sh "$script_path" "$mode"
}

run_macos_script_with_shell() {
    script_path="$1"

    if [ ! -f "$script_path" ]; then
        log_error "Script introuvable : $script_path"
        return 1
    fi

    if [ -n "${SHELL:-}" ] && [ -x "$SHELL" ]; then
        log_info "Rechargement du shell ($SHELL -l) et exécution de $(basename "$script_path")"
        if ! "$SHELL" -l -c "sh '$script_path'"; then
            log_error "$(basename "$script_path") a échoué via $SHELL"
            return 1
        fi
    else
        log_info "Variable SHELL manquante, exécution directe de $(basename "$script_path")"
        if ! sh "$script_path"; then
            log_error "$(basename "$script_path") a échoué"
            return 1
        fi
    fi

    log_success "$(basename "$script_path") terminé"
}

run_setup_script() {
    script_path="$DOTS_ROOT/$1"

    if [ ! -f "$script_path" ]; then
        log_error "Script introuvable : $script_path"
        return 1
    fi

    run_step "$1" sh "$script_path"
}

run_shell_setup() {
    script_path="$DOTS_ROOT/src/setup/shell.sh"
    run_step "shell.sh" sh "$script_path"
}

cmd_install() {
    os=$(detect_os)
    case "$os" in
        Windows)
            log_error "Installation impossible sur Windows"
            return 1
            ;;
        Linux)
            log_error "Installation non disponible sur Linux pour le moment"
            return 1
            ;;
        Unknown)
            log_error "Système d'exploitation inconnu : $(uname -s 2>/dev/null || echo inconnu)"
            return 1
            ;;
    esac

    if [ ! -t 0 ]; then
        log_error "Le mode interactif est requis. Lancez 'dots install' depuis un terminal."
        return 1
    fi

    print_os_info "$os"

    selection=""
    attempt=0

    while :; do
        if [ "$attempt" -ge "$MAX_INSTALL_ATTEMPTS" ]; then
            log_error "Nombre maximum de tentatives atteint"
            return 1
        fi
        attempt=$((attempt + 1))

        prompt_install_choice
        if ! read -r choice; then
            log_error "Lecture interrompue"
            return 1
        fi
        if selection=$(resolve_install_choice "$choice" 2>/dev/null); then
            break
        fi
        log_error "Choix invalide : $choice (options : 1=setup minimale, 2=setup complet)"
    done

    DOTS_ROOT=${DOTS_ROOT:-$HOME/.dotfiles}
    CACHE_DIR="$DOTS_ROOT/.cache"
    MODE_FILE="$CACHE_DIR/dots_install_mode"
    mkdir -p "$CACHE_DIR"
    printf '%s' "$selection" > "$MODE_FILE"

    case "$selection" in
        setup_minimale)
            log_info "Option setup minimale sélectionnée"
            if ! (
                run_link_global_setup "setup_minimale" &&
                {
                    if [ "$os" = "macOS" ]; then
                        if [ -n "${SHELL:-}" ] && [ -x "$SHELL" ]; then
                            log_info "Rechargement du shell ($SHELL -l)"
                            "$SHELL" -l >/dev/null 2>&1 || true
                        fi
                        run_setup_script "src/macOS/osx.sh" || return 1
                    fi
                    true
                }
            ); then
                log_error "Installation setup_minimale échouée"
                return 1
            fi

            run_shell_setup || return 1
            log_success "Installation setup_minimale terminée"
            ;;
        setup_complet)
            log_info "Option setup complet sélectionnée"
            if ! (
                run_link_global_setup "setup_complet" &&
                {
                    if [ "$os" = "macOS" ]; then
                        run_macos_script_with_shell "$DOTS_ROOT/src/macOS/full-setup.sh"
                    else
                        true
                    fi
                }
            ); then
                log_error "Installation setup_complet échouée"
                return 1
            fi

            if [ "$os" = "macOS" ]; then
                run_setup_script "src/setup/asdf.sh" || return 1
                run_setup_script "src/setup/tmux.sh" || return 1
            fi
            run_shell_setup || return 1
            log_success "Installation setup_complet terminée"
            ;;
    esac
}

