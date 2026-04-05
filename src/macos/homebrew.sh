#!/bin/sh
# macOS: install Homebrew if missing, then update / bundle / upgrade / cleanup.
set -eu

DOTS_ROOT="${DOTS_ROOT:-$(CDPATH= cd "$(dirname "$0")/../.." && pwd)}"
. "$DOTS_ROOT/lib/helpers.sh"

# Add Homebrew to PATH when the binary exists but is not yet on PATH.
ensure_brew_in_path() {
  if command -v brew >/dev/null 2>&1; then
    return 0
  fi
  if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
    return 0
  fi
  if [ -x /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv)"
    return 0
  fi
  return 1
}

install_brew() {
  info "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" \
    || fail "Homebrew installation failed"
  ensure_brew_in_path || fail "Homebrew installed but not found in PATH"
  info "Homebrew installed successfully"
}

load_env() {
  env_file="$DOTS_ROOT/.config/shell/env"
  if [ -f "$env_file" ]; then
    . "$env_file"
  fi
}

run_bundle() {
  brewfile="$DOTS_ROOT/Brewfile"
  if [ ! -f "$brewfile" ]; then
    warn "Brewfile not found, skipping bundle"
    return 0
  fi
  info "Installing Brewfile packages..."
  brew bundle --file="$brewfile"
  info "Brewfile done"
}

ensure_brew_in_path || install_brew
load_env

info "Updating Homebrew..."
brew update

run_bundle

info "Upgrading installed packages..."
brew upgrade

info "Cleaning up..."
brew cleanup

info "Homebrew setup complete"
