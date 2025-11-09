#!/bin/sh
# ==========================================
# ~/.dotfiles/src/common/shell/shell.sh
# Shell migration
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

log_info "📚 Shell migration..."

migrate_history() {
    shell_name="$1"
    old_file="$2"
    new_dir="$3"

    mkdir -p "$new_dir"

    if [ ! -f "$new_dir/history" ]; then
        if [ -f "$old_file" ]; then
            if cp "$old_file" "$new_dir/history"; then
                log_success "$shell_name history migrated"
            else
                log_error "Failed to copy $old_file"
            fi
        else
            : > "$new_dir/history"
            log_success "Empty $shell_name history created"
        fi
    else
        log_info "$shell_name history already present"
    fi

    if [ -f "$old_file" ]; then
        if [ -f "$new_dir/history" ] && [ -s "$new_dir/history" ]; then
            backup_file="$old_file.bak"
            if cp "$old_file" "$backup_file" >/dev/null 2>&1; then
                if rm "$old_file"; then
                    log_success "Old $old_file removed (backup: $backup_file)"
                else
                    log_error "Failed to remove $old_file"
                fi
            else
                log_error "Failed to create backup, keeping $old_file"
            fi
        else
            log_error "Migration verification failed, keeping $old_file"
        fi
    fi
}

migrate_history "Zsh" "$HOME/.zsh_history" "${XDG_STATE_HOME:-${HOME}/.local/state}/zsh"
if [ -f "$HOME/.local/share/zsh/history" ] && [ ! -f "${XDG_STATE_HOME:-${HOME}/.local/state}/zsh/history" ]; then
    log_info "Migrating Zsh history from DATA to STATE..."
    mkdir -p "${XDG_STATE_HOME:-${HOME}/.local/state}/zsh"
    cp "$HOME/.local/share/zsh/history" "${XDG_STATE_HOME:-${HOME}/.local/state}/zsh/history"
fi

migrate_history "Bash" "$HOME/.bash_history" "${XDG_STATE_HOME:-${HOME}/.local/state}/bash"
if [ -f "$HOME/.local/share/bash/history" ] && [ ! -f "${XDG_STATE_HOME:-${HOME}/.local/state}/bash/history" ]; then
    log_info "Migrating Bash history from DATA to STATE..."
    mkdir -p "${XDG_STATE_HOME:-${HOME}/.local/state}/bash"
    cp "$HOME/.local/share/bash/history" "${XDG_STATE_HOME:-${HOME}/.local/state}/bash/history"
fi

mkdir -p "$HOME/.cache/zsh" "$HOME/.cache/bash"
log_success "Cache directories ready"

log_success "Shell migration completed"