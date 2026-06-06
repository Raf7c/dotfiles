#!/usr/bin/env sh
# Module: runtimes — install the tools managed by mise (from its config).
#
# Prerequisite: `mise` on the PATH (installed by packages, + hash -r).
# We CHECK it explicitly here to avoid "mise: command not found".
#
# Contract:
#   - idempotent: `mise install` skips what is already installed
#   - OS: all; no sudo
#   - guard: if mise is missing (partial install), we skip cleanly
#   - dry-run: via run()
#
# Source of truth for versions: ~/.config/mise/config.toml (linked by symlinks).


hash -r 2>/dev/null || true

if ! command -v mise >/dev/null 2>&1 && [ ! -x "$HOME/.local/bin/mise" ]; then
  log_warn "mise missing -> step skipped (install via packages)"
  return 0
fi

# In case mise was just placed in ~/.local/bin without being "hashed" yet.
_mise=$(command -v mise 2>/dev/null || printf '%s' "$HOME/.local/bin/mise")

run "$_mise" trust "$HOME/.config/mise/config.toml"
run "$_mise" install
log_ok "runtimes (mise) installed from ~/.config/mise/config.toml"
