#!/bin/sh

# Initialise la journalisation pour les scripts dots

DOTS_ROOT=${DOTS_ROOT:-$HOME/.dotfiles}
DOTS_LOG_DIR=${DOTS_LOG_DIR:-"$DOTS_ROOT/logs"}
DOTS_LOG_FILE=${DOTS_LOG_FILE:-"$DOTS_LOG_DIR/dots.log"}

if [ -n "${DOTS_LOG_INITIALIZED:-}" ]; then
    return 0 2>/dev/null || true
fi

mkdir -p "$DOTS_LOG_DIR"

if ! command -v log_info >/dev/null 2>&1; then
    log_append_dots() {
        level="$1"
        shift
        message="$*"
        printf '%s [%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$level" "$message" >> "$DOTS_LOG_FILE"
    }

    log_error() {
        log_append_dots ERROR "$*"
        printf '❌ %s\n' "$*" >&2
    }

    log_info() {
        log_append_dots INFO "$*"
        printf 'ℹ️  %s\n' "$*"
    }

    log_success() {
        log_append_dots SUCCESS "$*"
        printf '✅ %s\n' "$*"
    }
fi

DOTS_LOG_INITIALIZED=1
