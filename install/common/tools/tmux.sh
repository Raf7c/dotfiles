#!/bin/sh
# ==========================================
# ~/tmux-tmp.sh
# Installing Tmux plugins
# ==========================================

set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

# Load utilities
. "$SCRIPT_DIR/../../lib/utils.sh"

echo "📦 Installing Tmux Plugin Manager..."

TPM_DIR="$HOME/.config/tmux/plugins/tpm"

if [ ! -d "$TPM_DIR" ]; then
    echo "⬇️ Cloning TPM repository..."
    mkdir -p "$HOME/.config/tmux/plugins"
    git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
    print_success "TPM installed successfully"
else
    print_success "TPM already installed"
fi

print_info "Run 'tmux' and press Ctrl+Space + I to install plugins"