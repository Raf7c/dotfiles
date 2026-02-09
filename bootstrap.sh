#!/bin/bash
# Bootstrap dotfiles : detection OS and configuration

set -eu

DOTS_ROOT="${DOTS_ROOT:-$(cd "$(dirname "$0")" && pwd)}"
export DOTS_ROOT
INSTALL_MACOS="$DOTS_ROOT/install/macos"

run_macos() {
  local f="$INSTALL_MACOS/$1"
  [ -f "$f" ] && ([ -x "$f" ] && "$f" || bash "$f") || true
}

case "$(uname -s)" in
  Darwin)
    echo "macOS detected — configuring..."
    run_macos osx.sh
    run_macos brew.sh
    run_macos asdf.sh
    run_macos links.sh
    run_macos tmux.sh
    run_macos shell.sh
    ;;
  *)
    echo "No configuration available for this OS."
    exit 0
    ;;
esac
