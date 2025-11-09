#!/bin/sh
# ==========================================
# ~/.dotfiles/src/common/tools/tmux.sh
# Installing Tmux plugins
# ==========================================

set -eu

DOTS_ROOT=${DOTS_ROOT:-$HOME/.dotfiles}
LOG_INIT="$DOTS_ROOT/src/lib/dots/log_init.sh"
if [ -f "$LOG_INIT" ]; then
    . "$LOG_INIT"
else
    log_info() { printf 'ℹ️  %s\n' "$*"; }
    log_error() { printf '❌ %s\n' "$*" >&2; }
    log_success() { printf '✅ %s\n' "$*"; }
fi

log_info "📦 Installation de Tmux Plugin Manager..."

TPM_DIR="$HOME/.config/tmux/plugins/tpm"

if [ ! -d "$TPM_DIR" ]; then
    log_info "⬇️  Clonage du dépôt TPM..."
    mkdir -p "$HOME/.config/tmux/plugins"
    if git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"; then
        log_success "TPM installé dans $TPM_DIR"
    else
        log_error "Échec du clonage de TPM"
        exit 1
    fi
else
    log_info "TPM déjà présent : $TPM_DIR"
fi

log_info "ℹ️  Lance tmux puis Ctrl+espace, I pour installer les plugins"