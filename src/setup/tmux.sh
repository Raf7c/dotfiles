#!/bin/sh
# ==========================================
# ~/src/setup/tmux.sh
# Installing Tmux plugins
# ==========================================

set -eu

TPM_DIR="$HOME/.config/tmux/plugins/tpm"

if [ ! -d "$TPM_DIR" ]; then
    mkdir -p "$HOME/.config/tmux/plugins"
    git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
fi