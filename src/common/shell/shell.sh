#!/bin/sh
# ==========================================
# ~/.dotfiles/src/common/shell/shell.sh
# Shell migration
# ==========================================

set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

# Load utilities
. "$SCRIPT_DIR/../../lib/utils.sh"

echo "📚 Shell migration..."

# Helper function for migration (POSIX-compliant)
migrate_history() {
    shell_name="$1"
    old_file="$2"
    new_dir="$3"
    
    mkdir -p "$new_dir"
    
    if [ ! -f "$new_dir/history" ]; then
        if [ -f "$old_file" ]; then
            cp "$old_file" "$new_dir/history"
            print_success "$shell_name history migrated"
        else
            : > "$new_dir/history"
            print_success "Empty $shell_name history created"
        fi
    else
        print_success "$shell_name history already present"
    fi
    
    # Cleanup with backup
    if [ -f "$old_file" ]; then
        # Verify migration succeeded
        if [ -f "$new_dir/history" ] && [ -s "$new_dir/history" ]; then
            # Create backup before removal
            backup_file="${old_file}.backup.$(date +%Y%m%d)"
            if cp "$old_file" "$backup_file"; then
                echo "💾 Backup saved: $backup_file"
                if rm "$old_file"; then
                    echo "🧹 Old $old_file removed"
                    print_info "You can delete backup after verifying: rm $backup_file"
                else
                    print_warning "Failed to remove $old_file"
                fi
            else
                print_warning "Failed to create backup, keeping $old_file"
            fi
        else
            print_warning "Migration verification failed, keeping $old_file"
        fi
    fi
}

# Zsh migration (use XDG_STATE_HOME for history)
migrate_history "Zsh" "$HOME/.zsh_history" "${XDG_STATE_HOME:-${HOME}/.local/state}/zsh"
# Also migrate from old DATA location if exists
if [ -f "$HOME/.local/share/zsh/history" ] && [ ! -f "${XDG_STATE_HOME:-${HOME}/.local/state}/zsh/history" ]; then
    print_info "Migrating Zsh history from DATA to STATE..."
    mkdir -p "${XDG_STATE_HOME:-${HOME}/.local/state}/zsh"
    cp "$HOME/.local/share/zsh/history" "${XDG_STATE_HOME:-${HOME}/.local/state}/zsh/history"
fi

# Bash migration (use XDG_STATE_HOME for history)
migrate_history "Bash" "$HOME/.bash_history" "${XDG_STATE_HOME:-${HOME}/.local/state}/bash"
# Also migrate from old DATA location if exists
if [ -f "$HOME/.local/share/bash/history" ] && [ ! -f "${XDG_STATE_HOME:-${HOME}/.local/state}/bash/history" ]; then
    print_info "Migrating Bash history from DATA to STATE..."
    mkdir -p "${XDG_STATE_HOME:-${HOME}/.local/state}/bash"
    cp "$HOME/.local/share/bash/history" "${XDG_STATE_HOME:-${HOME}/.local/state}/bash/history"
fi

# Cache directories
mkdir -p "$HOME/.cache/zsh" "$HOME/.cache/bash"
print_success "Cache directories ready"

print_success "Shell migration completed"