#!/bin/sh
# ==========================================
# ~/.dotfiles/install/common/shell/shell.sh
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
            cp "$old_file" "$backup_file"
            rm "$old_file"
            echo "🧹 Old $old_file removed"
            echo "💾 Backup saved: $backup_file"
            print_info "You can delete backup after verifying: rm $backup_file"
        else
            print_warning "Migration verification failed, keeping $old_file"
        fi
    fi
}

# Zsh migration
migrate_history "Zsh" "$HOME/.zsh_history" "$HOME/.local/share/zsh"

# Bash migration
migrate_history "Bash" "$HOME/.bash_history" "$HOME/.local/share/bash"

# Cache directories
mkdir -p "$HOME/.cache/zsh" "$HOME/.cache/bash"
print_success "Cache directories ready"

print_success "Shell migration completed"