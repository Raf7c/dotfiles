#!/usr/bin/env sh
# macOS defaults (Dock, Finder, screenshots, etc.)
set -eu

defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-time-modifier -float 0
defaults write com.apple.dock autohide-delay -float 0.0
defaults write com.apple.dock mru-spaces -bool false
defaults write com.apple.dock show-recents -bool false

defaults write com.apple.finder FXPreferredViewStyle -string "clmv"
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write com.apple.finder AppleShowAllExtensions -bool true

defaults write NSGlobalDomain AppleICUForce24HourTime -bool true
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

mkdir -p "$HOME/Pictures/screenshots"
defaults write com.apple.screencapture location -string "$HOME/Pictures/screenshots"
defaults write com.apple.screencapture type -string "png"

# iCloud Drive -> ~/icloud (short path)
# -n handles an existing SYMLINK; a real directory would silently get the
# link created INSIDE it.
if [ -e "$HOME/icloud" ] && [ ! -L "$HOME/icloud" ]; then
  printf 'icloud: real file/directory at ~/icloud, skipped\n' >&2
else
  ln -sfn "$HOME/Library/Mobile Documents/com~apple~CloudDocs" "$HOME/icloud"
fi

# Spotlight: disable the keyboard shortcut (⌘ Space)
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 64 "<dict><key>enabled</key><false/><key>value</key><dict><key>parameters</key><array><integer>65535</integer><integer>49</integer><integer>1048576</integer></array><key>type</key><string>standard</string></dict></dict>"

# Apply. activateSettings lives in a PRIVATE framework: guard its presence,
# any macOS update may move or remove it.
_as=/System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings
if [ -x "$_as" ]; then
  "$_as" -u || true
fi
killall Dock 2>/dev/null || true
killall Finder 2>/dev/null || true
killall SystemUIServer 2>/dev/null || true
