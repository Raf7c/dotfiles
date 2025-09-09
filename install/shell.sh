#!/bin/sh
# ==========================================
# Zsh & Bash history & cache migration (POSIX)
# ==========================================

echo "📚 Migrating Zsh history"

# Historique Zsh (toujours sous ~/.local/share/zsh)
HIST_DIR="$HOME/.local/share/zsh"
mkdir -p -- "$HIST_DIR"

if [ ! -f "$HIST_DIR/history" ]; then
    if [ -f "$HOME/.zsh_history" ]; then
        cp "$HOME/.zsh_history" "$HIST_DIR/history"
        echo "✅ Zsh history migrated"
    else
        : > "$HIST_DIR/history"
        echo "✅ Empty Zsh history file created"
    fi
else
    echo "✅ Zsh history already present"
fi

# Supprimer ancien fichier Zsh si encore présent
if [ -f "$HOME/.zsh_history" ]; then
    rm "$HOME/.zsh_history"
    echo "🧹 Old ~/.zsh_history file removed"
else
    echo "👌 No old Zsh history file found"
fi

# Cache complétions Zsh (toujours sous ~/.cache/zsh)
COMP_DIR="$HOME/.cache/zsh"
mkdir -p -- "$COMP_DIR"
echo "✅ Zsh completion cache directory ready at $COMP_DIR"


echo "📚 Migrating Bash history"

# Historique Bash (toujours sous ~/.local/share/bash)
BASH_HIST_DIR="$HOME/.local/share/bash"
mkdir -p -- "$BASH_HIST_DIR"

if [ ! -f "$BASH_HIST_DIR/history" ]; then
    if [ -f "$HOME/.bash_history" ]; then
        cp "$HOME/.bash_history" "$BASH_HIST_DIR/history"
        echo "✅ Bash history migrated"
    else
        : > "$BASH_HIST_DIR/history"
        echo "✅ Empty Bash history file created"
    fi
else
    echo "✅ Bash history already present"
fi

# Supprimer ancien fichier Bash si encore présent
if [ -f "$HOME/.bash_history" ]; then
    rm "$HOME/.bash_history"
    echo "🧹 Old ~/.bash_history file removed"
else
    echo "👌 No old Bash history file found"
fi

# (Optionnel) Cache pour Bash si tu veux suivre la même logique
BASH_COMP_DIR="$HOME/.cache/bash"
mkdir -p -- "$BASH_COMP_DIR"
echo "✅ Bash cache directory ready at $BASH_COMP_DIR"

