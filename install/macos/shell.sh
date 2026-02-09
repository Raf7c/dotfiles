#!/bin/bash
# Shell migration: XDG history and cache (minimal)

set -eu

STATE="${XDG_STATE_HOME:-$HOME/.local/state}"
CACHE="${XDG_CACHE_HOME:-$HOME/.cache}"

# Zsh
mkdir -p "$STATE/zsh"
if [ -f "$HOME/.zsh_history" ] && [ ! -f "$STATE/zsh/history" ]; then
  cp "$HOME/.zsh_history" "$STATE/zsh/history"
  echo "Zsh history migrated to $STATE/zsh/history"
fi

# Bash
mkdir -p "$STATE/bash"
if [ -f "$HOME/.bash_history" ] && [ ! -f "$STATE/bash/history" ]; then
  cp "$HOME/.bash_history" "$STATE/bash/history"
  echo "Bash history migrated to $STATE/bash/history"
fi

# Cache
mkdir -p "$CACHE/zsh" "$CACHE/bash"
echo "Shell migration done."
