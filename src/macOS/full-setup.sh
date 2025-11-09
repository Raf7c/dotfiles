#!/bin/sh
# ==========================================
# ~/.dotfiles/src/macOS/full-setup.sh
# Regroupe la configuration complète macOS
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

run_part() {
    label="$1"
    shift
    log_info "▶️  ${label}"
    if "$@"; then
        log_success "${label} terminé"
    else
        log_error "${label} a échoué"
        return 1
    fi
}

run_part "homebrew.sh" sh "$DOTS_ROOT/src/macOS/homebrew.sh"
run_part "packages.sh" sh "$DOTS_ROOT/src/macOS/packages.sh"
run_part "refresh-gcc-cache.sh" sh "$DOTS_ROOT/src/macOS/refresh-gcc-cache.sh"
run_part "osx.sh" sh "$DOTS_ROOT/src/macOS/osx.sh"
