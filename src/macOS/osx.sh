#!/bin/sh
# ==========================================
# ~/.dotfiles/src/macOS/osx.sh
# macOS system preferences configuration
# ==========================================

set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

# Load utilities
. "$SCRIPT_DIR/../lib/utils.sh"

echo "⚙️ macOS Configuration..."

# Configuration by groups
echo "📱 Dock..."
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-time-modifier -float 0
defaults write com.apple.dock autohide-delay -float 0.0
defaults write com.apple.dock mru-spaces -bool false
defaults write com.apple.dock show-recents -bool false

echo "📁 Finder..."
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write com.apple.finder AppleShowAllExtensions -bool true

echo "🌐 System..."
defaults write NSGlobalDomain AppleICUForce24HourTime -bool true
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

echo "📸 Screenshots..."
mkdir -p "$HOME/Pictures/screenshots"
defaults write com.apple.screencapture location -string "$HOME/Pictures/screenshots"
defaults write com.apple.screencapture type -string "png"

echo "🔄 Restarting services..."
killall Dock 2>/dev/null || true
killall Finder 2>/dev/null || true
killall SystemUIServer 2>/dev/null || true

print_success "macOS configuration complete"