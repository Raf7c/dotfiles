#!/bin/sh
# ==========================================
# ~/.dotfiles/src/macOS/osx.sh
# macOS system preferences configuration
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

log_info "⚙️  Configuration de macOS..."

log_info "📱 Dock..."
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-time-modifier -float 0
defaults write com.apple.dock autohide-delay -float 0.0
defaults write com.apple.dock mru-spaces -bool false
defaults write com.apple.dock show-recents -bool false

log_info "📁 Finder..."
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write com.apple.finder AppleShowAllExtensions -bool true

log_info "🌐 Système..."
defaults write NSGlobalDomain AppleICUForce24HourTime -bool true
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

log_info "📸 Captures d'écran..."
mkdir -p "$HOME/Pictures/screenshots"
defaults write com.apple.screencapture location -string "$HOME/Pictures/screenshots"
defaults write com.apple.screencapture type -string "png"

log_info "🔄 Redémarrage des services..."
killall Dock 2>/dev/null || true
killall Finder 2>/dev/null || true
killall SystemUIServer 2>/dev/null || true

log_success "Configuration macOS terminée"