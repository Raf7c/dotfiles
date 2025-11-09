#!/bin/sh
# ==========================================
# ~/.dotfiles/src/common/tools/asdf.sh
# Installing asdf plugins and versions
# ==========================================

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

log_info "📦 Installation des plugins et versions asdf..."

TOOL_VERSIONS_FILE="$DOTS_ROOT/.tool-versions"

if [ ! -f "$TOOL_VERSIONS_FILE" ]; then
    log_error "Fichier .tool-versions introuvable : $TOOL_VERSIONS_FILE"
    exit 1
fi

if ! command -v asdf >/dev/null 2>&1; then
    log_error "asdf n'est pas installé ou absent du PATH"
    exit 1
fi

log_info "📖 Lecture de $TOOL_VERSIONS_FILE"

autres_plugins="$(asdf plugin list)"

while IFS=' ' read -r plugin version || [ -n "$plugin" ]; do
    [ -z "$plugin" ] && continue
    case "$plugin" in
        \#*) continue ;;
    esac
    [ -z "$version" ] && continue

    log_info "🔧 $plugin $version"

    if ! printf '%s\n' "$autres_plugins" | grep -q "^${plugin}$"; then
        log_info "  ⬇️ Installation du plugin $plugin"
        if asdf plugin add "$plugin"; then
            log_success "  Plugin $plugin installé"
            autres_plugins="$(printf '%s\n%s' "$autres_plugins" "$plugin")"
        else
            log_error "  Impossible d'installer le plugin $plugin"
            continue
        fi
    else
        log_info "  Plugin $plugin déjà présent"
    fi

    if ! asdf list "$plugin" 2>/dev/null | grep -q "^[[:space:]]*${version}$"; then
        log_info "  ⬇️ Installation de la version $version"
        if asdf install "$plugin" "$version"; then
            log_success "  Version $version installée"
        else
            log_error "  Impossible d'installer la version $version"
            continue
        fi
    else
        log_info "  Version $version déjà installée"
    fi

    log_info ""
done < "$TOOL_VERSIONS_FILE"

log_success "Installation asdf terminée"
log_info "ℹ️  Pense à exécuter 'asdf reshim' si nécessaire"
