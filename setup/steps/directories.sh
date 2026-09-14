#!/usr/bin/env sh
# Step directories: create the XDG directories the shells need before their
# first start. The list is in manifest.sh (dotfiles_dirs).

. "$DOTFILES_DIR/setup/manifest.sh"

dotfiles_dirs | while IFS= read -r _dir; do
  [ -z "${_dir:-}" ] && continue
  case "$_dir" in \#*) continue ;; esac
  # run_soft, not run: the counters live in FILES (log.sh), so log_error still
  # works from this subshell -- a plain variable increment would be lost here.
  run_soft mkdir -p -- "$_dir"
done

log_done_clean "XDG directories ready" \
  "XDG directories: some could not be created (see the ✗ above)"
