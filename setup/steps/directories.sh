#!/usr/bin/env sh
# Module: directories — create the required XDG directories. *** COMPLETE MODULE ***
# Contract:
#
#   - idempotent: mkdir -p
#   - OS: all; no sudo (everything under $HOME)
#   - dry-run: via run()
#
# The directory list (computed from XDG) is in manifest.sh: dotfiles_dirs.

. "$DOTFILES_DIR/setup/manifest.sh"

dotfiles_dirs | while IFS= read -r _dir; do
  [ -z "${_dir:-}" ] && continue
  case "$_dir" in \#*) continue ;; esac
  run mkdir -p "$_dir"
done

log_ok "XDG directories ready"
