#!/usr/bin/env sh
# Step migrate: move legacy history files (~/.bash_history, ~/.zsh_history…)
# to their XDG location. Runs once per machine, before the first shell.

. "$DOTFILES_DIR/setup/manifest.sh"

dotfiles_history_migrations | while read -r _old _new _rest; do
  [ -z "${_old:-}" ] && continue
  case "$_old" in \#*) continue ;; esac
  migrate_file "$_old" "$_new"
done

log_ok "history migrations ok"
