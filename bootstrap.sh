#!/bin/sh
set -eu

echo "🚀 Configuration de l'environnement macOS"

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

# Vérification macOS via uname
case "$(uname -s)" in
    Darwin) : ;;  # OK → rien à faire
    *) echo "❌ Ce script doit être exécuté sur macOS" >&2; exit 1 ;;
esac

# Liens symboliques
[ -f "$SCRIPT_DIR/install/link_global.sh" ] || { echo "❌ link_global.sh introuvable" >&2; exit 1; }
sh "$SCRIPT_DIR/install/link_global.sh" && echo "✅ Liens symboliques créés"

# Homebrew
[ -f "$SCRIPT_DIR/install/macOS/homebrew.sh" ] || { echo "❌ homebrew.sh introuvable" >&2; exit 1; }
sh "$SCRIPT_DIR/install/macOS/homebrew.sh" && echo "✅ Homebrew configuré"

source ~/.zshenv

# Shell commun
[ -f "$SCRIPT_DIR/install/shell.sh" ] || { echo "❌ shell.sh introuvable" >&2; exit 1; }
sh "$SCRIPT_DIR/install/shell.sh" && echo "✅ Shell configuré"

# Configuration macOS
[ -f "$SCRIPT_DIR/install/macOS/osx.sh" ] || { echo "❌ osx.sh introuvable" >&2; exit 1; }
sh "$SCRIPT_DIR/install/macOS/osx.sh" && echo "✅ Configuration macOS terminée"

echo "🎉 Configuration terminée !"
echo "💡 Certains changements peuvent nécessiter un redémarrage complet."
