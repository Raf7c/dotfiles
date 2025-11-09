#!/bin/sh
# ==========================================
# ~/.dotfiles/src/macOS/refresh-gcc-cache.sh
# Generate GCC aliases cache for Homebrew
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

log_info "🔄 Actualisation du cache GCC..."

mkdir -p "$HOME/.cache"

if command -v brew >/dev/null 2>&1 && brew list gcc >/dev/null 2>&1; then
    GCC_PREFIX=$(brew --prefix gcc 2>/dev/null || echo "")

    if [ -n "$GCC_PREFIX" ] && [ -d "$GCC_PREFIX/bin" ]; then
        GCC_VERSION=$(brew list --versions gcc 2>/dev/null | awk '{print $NF}' | grep -oE '^[0-9]+' || echo "")

        if [ -z "$GCC_VERSION" ]; then
            GCC_VERSION=$(ls "$GCC_PREFIX/bin"/gcc-* 2>/dev/null | head -n1 | grep -oE '[0-9]+$' || echo "")
        fi

        if [ -n "$GCC_VERSION" ] && [ -f "$GCC_PREFIX/bin/gcc-$GCC_VERSION" ]; then
            cat > "$HOME/.cache/gcc_aliases" <<EOF
# Auto-generated GCC aliases
# Regenerate with: sh ~/.dotfiles/src/macOS/refresh-gcc-cache.sh
alias gcc="$GCC_PREFIX/bin/gcc-$GCC_VERSION"
alias g++="$GCC_PREFIX/bin/g++-$GCC_VERSION"
EOF
            log_success "Cache GCC créé pour gcc-$GCC_VERSION"
            log_info "📍 Fichier : $HOME/.cache/gcc_aliases"
        else
            log_error "Impossible de détecter la version de GCC"
        fi
    else
        log_error "Dossier GCC introuvable : ${GCC_PREFIX:-inconnu}/bin"
    fi
else
    log_info "GCC n'est pas installé via Homebrew"
    rm -f "$HOME/.cache/gcc_aliases"
fi