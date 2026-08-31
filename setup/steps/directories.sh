#!/usr/bin/env sh
# Step directories: create the XDG directories the shells need before their
# first start. The list is in manifest.sh (dotfiles_dirs).

. "$DOTFILES_DIR/setup/manifest.sh"

dotfiles_dirs | while IFS= read -r _dir; do
  [ -z "${_dir:-}" ] && continue
  case "$_dir" in \#*) continue ;; esac
  run mkdir -p -- "$_dir"
done

log_done "XDG directories ready"
