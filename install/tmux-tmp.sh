#!/bin/sh
# ==========================================
# tmux-tpm-install.sh
# ==========================================

set -eu

TPM_DIR="$HOME/.tmux/plugins/tpm"

if [ ! -d "$TPM_DIR" ]; then
    echo "📦 Installing TPM..."
    mkdir -p "$HOME/.tmux/plugins"
    git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
    echo "✅ TPM installed"
else
    echo "✅ TPM already installed"
fi