#!/bin/sh
# ==========================================
# ~/shell.sh
# ==========================================

set -eu

echo "📚 Shell migration..."

# Helper function for migration (POSIX-compliant)
migrate_history() {
    local shell_name="$1"
    local old_file="$2"
    local new_dir="$3"
    
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
    
    # Cleanup
    [ -f "$old_file" ] && rm "$old_file" && echo "🧹 Old $old_file removed"
}

# Zsh migration
migrate_history "Zsh" "$HOME/.zsh_history" "$HOME/.local/share/zsh"

# Bash migration
migrate_history "Bash" "$HOME/.bash_history" "$HOME/.local/share/bash"

# Cache directories
mkdir -p "$HOME/.cache/zsh" "$HOME/.cache/bash"
echo "✅ Cache directories ready"

echo "✅ Shell migration completed"