#!/bin/sh
set -eu

STATE="${XDG_STATE_HOME:-$HOME/.local/state}"
CACHE="${XDG_CACHE_HOME:-$HOME/.cache}"

migrate_history() {
  shell="$1"
  src="$2"
  dest="$STATE/$shell/history"

  mkdir -p "$STATE/$shell"
  if [ -f "$src" ] && [ ! -f "$dest" ]; then
    cp "$src" "$dest"
    printf '%s history migrated to %s\n' "$shell" "$dest"
  fi
}

migrate_history "zsh"  "$HOME/.zsh_history"
migrate_history "bash" "$HOME/.bash_history"

mkdir -p "$CACHE/zsh" "$CACHE/bash"
printf 'Shell migration done.\n'
