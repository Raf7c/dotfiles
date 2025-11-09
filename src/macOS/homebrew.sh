#!/bin/sh
# ==========================================
# ~/.dotfiles/src/macOS/homebrew.sh
# Install and configure Homebrew
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

log_info "🍺 Configuration de Homebrew..."

if command -v brew >/dev/null 2>&1; then
    brew_info=$(brew --version | head -n1)
    log_success "Homebrew déjà installé : $brew_info"
elif [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
    brew_info=$(brew --version | head -n1)
    log_success "Homebrew détecté : $brew_info"
elif [ -x /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv)"
    brew_info=$(brew --version | head -n1)
    log_success "Homebrew détecté : $brew_info"
else
    log_info "⬇️  Installation de Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    if [ -x /opt/homebrew/bin/brew ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [ -x /usr/local/bin/brew ]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi

    brew_info=$(brew --version | head -n1)
    log_success "Homebrew installé : $brew_info"
fi

