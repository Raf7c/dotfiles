#!/bin/bash
# Tmux: install Plugin Manager (TPM)

set -eu

DOTS_ROOT="${DOTS_ROOT:-$(cd "$(dirname "$0")/../.." && pwd)}"

TPM_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/tmux/plugins/tpm"

if [ ! -d "$TPM_DIR" ]; then
  echo "Installing TPM in $TPM_DIR..."
  mkdir -p "$(dirname "$TPM_DIR")"
  if git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"; then
    echo "TPM installed."
  else
    echo "Failed to clone TPM."
    exit 1
  fi
else
  echo "TPM already present: $TPM_DIR"
fi

echo "In tmux: prefix + I to install plugins listed in tmux.conf"
