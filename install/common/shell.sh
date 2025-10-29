#!/bin/sh
# ==========================================
# ~/shell.sh
# Shell migration
# ==========================================

set -eu

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
            echo "✅ $shell_name history migrated"
        else
            : > "$new_dir/history"
            echo "✅ Empty $shell_name history created"
        fi
    else
        echo "✅ $shell_name history already present"
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
            echo "💡 You can delete backup after verifying: rm $backup_file"
        else
            echo "⚠️  Migration verification failed, keeping $old_file"
        fi
    fi
}

# Zsh migration
migrate_history "Zsh" "$HOME/.zsh_history" "$HOME/.local/share/zsh"

# Bash migration
migrate_history "Bash" "$HOME/.bash_history" "$HOME/.local/share/bash"

# Cache directories
mkdir -p "$HOME/.cache/zsh" "$HOME/.cache/bash"
echo "✅ Cache directories ready"

echo "✅ Shell migration completed"