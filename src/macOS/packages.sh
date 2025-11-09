#!/bin/sh
# ==========================================
# ~/.dotfiles/src/macOS/packages.sh
# Install packages on macOS with Homebrew
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

log_info "📦 Installation des paquets Homebrew..."

if ! command -v brew >/dev/null 2>&1; then
    log_error "Homebrew n'est pas disponible. Lance d'abord homebrew.sh"
    exit 1
fi

BREWFILE="$DOTS_ROOT/Brewfile"

if [ ! -f "$BREWFILE" ]; then
    log_error "Brewfile introuvable : $BREWFILE"
    exit 1
fi

log_info "📖 Lecture de $BREWFILE"

if brew bundle --file="$BREWFILE"; then
    log_success "Paquets installés à partir du Brewfile"
else
    log_error "brew bundle a retourné une erreur"
    exit 1
fi
