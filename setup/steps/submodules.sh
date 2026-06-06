#!/usr/bin/env sh
# Module: submodules — initialize/sync the repo's git submodules
#
# Contract:
#   - idempotent: `submodule update --init` is a no-op if already up to date
#   - OS: all; no sudo
#   - depends on prereqs (git); runs BEFORE symlinks (so the submodule
#     directory is populated when we link it)
#   - reconcilable: replayed by `update` (resync to the repo's commit after pull)
#   - requires access to the submodule remote (SSH/HTTPS configured)
#   - dry-run: via run()

if [ -f "$DOTFILES_DIR/.gitmodules" ]; then
  run git -C "$DOTFILES_DIR" submodule update --init --recursive
  log_ok "submodules synced (pinned commit)"
else
  log_info "no submodule (.gitmodules missing) — nothing to do"
fi
