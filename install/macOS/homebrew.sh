#!/bin/sh
# ==========================================
# ~/hombrew.sh
# ==========================================
set -eu

echo "🔍 Vérification de Homebrew..."

if command -v brew >/dev/null 2>&1; then
    :
elif [ -x /opt/homebrew/bin/brew ]; then
    # Homebrew est installé mais pas dans le PATH de cette session
    eval "$(/opt/homebrew/bin/brew shellenv)"
    echo "ℹ️ Homebrew détecté et ajouté au PATH pour cette session."
else
    echo "⬇️ Installation de Homebrew..."
    /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # Charger Homebrew pour la session courante
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Affiche la version (utile pour vérifier rapidement)
echo "✅ Homebrew prêt : $(brew --version | head -n1)"

# ----------------------------
# Application du Brewfile
# ----------------------------
BREWFILE="${1:-$HOME/.dotfiles/Brewfile}"

if [ -f "$BREWFILE" ]; then
    echo "📦 Installation depuis $BREWFILE..."
    brew bundle --file="$BREWFILE"
    echo "✅ Terminé!"
else
    echo "⚠️ Brewfile introuvable: $BREWFILE"
    exit 1
fi

