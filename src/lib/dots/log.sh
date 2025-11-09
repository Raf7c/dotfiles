#!/bin/sh

# Logging helpers for dots CLI

DOTS_ROOT=${DOTS_ROOT:-$HOME/.dotfiles}
DOTS_LOG_DIR=${DOTS_LOG_DIR:-"$DOTS_ROOT/logs"}
DOTS_LOG_FILE=${DOTS_LOG_FILE:-"$DOTS_LOG_DIR/dots.log"}

mkdir -p "$DOTS_LOG_DIR"

dots_log_append() {
    level="$1"
    shift
    message="$*"
    printf '%s [%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$level" "$message" >> "$DOTS_LOG_FILE"
}

log_error() {
    dots_log_append ERROR "$*"
    printf '❌ %s\n' "$*" >&2
}

log_info() {
    dots_log_append INFO "$*"
    printf 'ℹ️  %s\n' "$*"
}

log_success() {
    dots_log_append SUCCESS "$*"
    printf '✅ %s\n' "$*"
}

