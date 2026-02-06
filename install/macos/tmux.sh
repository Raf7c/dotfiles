#!/bin/bash
# Tmux : installation du Plugin Manager (TPM)

set -eu

DOTS_ROOT="${DOTS_ROOT:-$(cd "$(dirname "$0")/../.." && pwd)}"

TPM_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/tmux/plugins/tpm"

if [ ! -d "$TPM_DIR" ]; then
  echo "Installation de TPM dans $TPM_DIR..."
  mkdir -p "$(dirname "$TPM_DIR")"
  if git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"; then
    echo "TPM installé."
  else
    echo "Échec du clonage de TPM."
    exit 1
  fi
else
  echo "TPM déjà présent : $TPM_DIR"
fi

echo "Dans tmux : prefix + I pour installer les plugins listés dans tmux.conf"
