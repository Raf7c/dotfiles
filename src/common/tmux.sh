#!/bin/sh
# TPM (Tmux Plugin Manager) — clone if missing.
set -eu

DOTS_ROOT="${DOTS_ROOT:-$(CDPATH= cd "$(dirname "$0")/../.." && pwd)}"
. "$DOTS_ROOT/lib/helpers.sh"

TPM_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/tmux/plugins/tpm"

if [ ! -d "$TPM_DIR" ]; then
  info "Installing TPM in $TPM_DIR..."
  mkdir -p "$(dirname "$TPM_DIR")"
  git clone https://github.com/tmux-plugins/tpm "$TPM_DIR" \
    || fail "TPM clone failed"
  info "TPM installed"
else
  info "TPM already present ($TPM_DIR)"
fi

info "In tmux: prefix + I to install plugins (see tmux.conf)"
