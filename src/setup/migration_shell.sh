#!/bin/sh
# ==========================================
# ~/src/setup/migration_shell.sh
# Migrating shell history to XDG_STATE_HOME
# ==========================================

set -eu

migrate_history() {
    old_file="$1"
    new_dir="$2"

    mkdir -p "$new_dir"

    if [ ! -f "$new_dir/history" ]; then
        if [ -f "$old_file" ]; then
            cp "$old_file" "$new_dir/history"
            rm -f "$old_file"
        else
            : > "$new_dir/history"
        fi
    fi
}

STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

# Migrate Zsh history
migrate_history "$HOME/.zsh_history" "$STATE_HOME/zsh"
if [ -f "$HOME/.local/share/zsh/history" ] && [ ! -f "$STATE_HOME/zsh/history" ]; then
    mkdir -p "$STATE_HOME/zsh"
    cp "$HOME/.local/share/zsh/history" "$STATE_HOME/zsh/history"
fi

# Migrate Bash history
migrate_history "$HOME/.bash_history" "$STATE_HOME/bash"
if [ -f "$HOME/.local/share/bash/history" ] && [ ! -f "$STATE_HOME/bash/history" ]; then
    mkdir -p "$STATE_HOME/bash"
    cp "$HOME/.local/share/bash/history" "$STATE_HOME/bash/history"
fi

