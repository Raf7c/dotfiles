#!/bin/sh
# ==========================================
# ~/tmux-tmp.sh
# Installing Tmux plugins
# ==========================================

set -eu

echo "📦 Installing Tmux Plugin Manager..."

TPM_DIR="$HOME/.config/tmux/plugins/tpm"

if [ ! -d "$TPM_DIR" ]; then
    echo "⬇️ Cloning TPM repository..."
    mkdir -p "$HOME/.config/tmux/plugins"
    git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
    echo "✅ TPM installed successfully"
else
    echo "✅ TPM already installed"
fi

echo "💡 Run 'tmux' and press Ctrl+Space + I to install plugins"