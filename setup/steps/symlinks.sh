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
  [ -z "${_src:-}" ] && continue
  case "$_src" in \#*) continue ;; esac
  # A manifest line is EXACTLY "<source> <target>". A missing target would
  # make link_with_backup link into "$HOME/" itself, and an extra field is
  # a typo (or a path with spaces, unsupported by design). Refuse both
  # instead of dropping a link in the wrong place.
  if [ -z "${_dst:-}" ] || [ -n "${_rest:-}" ]; then
    log_error "manifest: invalid line, expected 2 fields: $_src ${_dst:-} ${_rest:-}"
    continue
  fi
  link_with_backup "$_src" "$_dst"
done
