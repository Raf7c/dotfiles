#!/usr/bin/env sh
# Step directories: create the XDG directories the shells need before their
# first start. The list is in manifest.sh (dotfiles_dirs).

. "$DOTFILES_DIR/setup/manifest.sh"

dotfiles_dirs | while IFS= read -r _dir; do
  [ -z "${_dir:-}" ] && continue
  case "$_dir" in \#*) continue ;; esac
  # run_soft, not run: a mkdir that fails must be counted, not swallowed. The
  # counters live in files (log.sh), so log_error works from this subshell.
  run_soft mkdir -p -- "$_dir"
done

# Like symlinks and migrate, the two other manifest consumers: this line says
# the step ran, not that every directory was created. Each failure printed its
# own ✗ through run_soft above, and log_summary owns the exit code.
log_done "XDG directories ready"
