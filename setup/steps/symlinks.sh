#!/usr/bin/env sh
# Module: symlinks — apply the link manifest.
#
# Contract:
#   - idempotent: link_with_backup does nothing if the link is already correct,
#     and backs up (timestamped) any existing real target before linking
#   - OS: all; no sudo
#   - dry-run: link_with_backup routes its actions through run()

. "$DOTFILES_DIR/setup/manifest.sh"

dotfiles_links | while read -r _src _dst _rest; do
  # ignore empty lines and comments
  [ -z "${_src:-}" ] && continue
  case "$_src" in \#*) continue ;; esac
  link_with_backup "$_src" "$_dst"
done
