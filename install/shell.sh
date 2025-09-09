#!/bin/sh
# ==========================================
# Zsh history & cache migration (POSIX)
# ==========================================

echo "📚 Migrating Zsh history"

# Historique Zsh (toujours sous ~/.local/share/zsh)
HIST_DIR="$HOME/.local/share/zsh"
mkdir -p -- "$HIST_DIR"

if [ ! -f "$HIST_DIR/history" ]; then
    if [ -f "$HOME/.zsh_history" ]; then
        cp "$HOME/.zsh_history" "$HIST_DIR/history"
        echo "✅ History migrated"
    else
        : > "$HIST_DIR/history"
        echo "✅ Empty history file created"
    fi
else
    echo "✅ History already present"
fi

# Supprimer ancien fichier si encore présent
if [ -f "$HOME/.zsh_history" ]; then
    rm "$HOME/.zsh_history"
    echo "🧹 Old ~/.zsh_history file removed"
else
    echo "👌 No old history file found"
fi

# Cache complétions Zsh (toujours sous ~/.cache/zsh)
COMP_DIR="$HOME/.cache/zsh"
mkdir -p -- "$COMP_DIR"
echo "✅ Zsh completion cache directory ready at $COMP_DIR"
