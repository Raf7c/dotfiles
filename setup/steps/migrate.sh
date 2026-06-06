#!/usr/bin/env sh
# Module: migrate — move legacy history files (~/.bash_history, ~/.zsh_history…)
# to their XDG location. *** COMPLETE MODULE (like symlinks) ***
#
# Contract:
#   - idempotent: migrate_file does nothing if the source is missing / already linked;
#     if the target already exists, the old file goes to backup (no overwrite)
#   - OS: all; no sudo
#   - depends on directories (XDG dirs created); runs BEFORE the first shell
#   - dry-run: migrate_file routes its actions through run()

. "$DOTFILES_DIR/setup/manifest.sh"

dotfiles_history_migrations | while read -r _old _new _rest; do
  [ -z "${_old:-}" ] && continue
  case "$_old" in \#*) continue ;; esac
  migrate_file "$_old" "$_new"
done
