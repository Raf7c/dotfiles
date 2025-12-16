#!/bin/sh

set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
DOTS_ROOT="$SCRIPT_DIR"

echo "🚀 Installation des dotfiles..."

echo "📦 Initialisation des sous-modules Git..."
git submodule update --init --recursive --remote
git submodule foreach 'git checkout main || true'

echo "🔗 Création des liens symboliques..."
sh "$DOTS_ROOT/src/setup/link_global.sh"

echo "📦 Installation de Homebrew et des paquets..."
sh "$DOTS_ROOT/src/macOS/homebrew.sh"

if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi

echo "📚 Migration de l'historique shell..."
sh "$DOTS_ROOT/src/setup/migration_shell.sh"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

echo "🔌 Installation de Tmux Plugin Manager..."
sh "$DOTS_ROOT/src/setup/tmux.sh"

echo "🔧 Installation des plugins asdf..."
if command -v asdf >/dev/null 2>&1; then
    sh "$DOTS_ROOT/src/setup/asdf.sh"
else
    echo "⚠️  asdf non trouvé, skip..."
fi

echo "⚙️  Configuration de macOS..."
sh "$DOTS_ROOT/src/macOS/osx.sh"

echo "🔄 Génération du cache GCC..."
sh "$DOTS_ROOT/src/macOS/refresh-gcc-cache.sh"

echo ""
echo "✅ Installation terminée !"
echo "💡 Redémarrez votre terminal ou exécutez: exec zsh"

