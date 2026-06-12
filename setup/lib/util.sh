#!/usr/bin/env sh
# lib/util.sh — general helpers (POSIX). Depends on log.sh (already sourced).
# The DRY_RUN / ASSUME_YES flags and DOTFILES_DIR are set by run.

: "${DRY_RUN:=0}"
: "${ASSUME_YES:=0}"
: "${DOTFILES_DIR:?DOTFILES_DIR must be set}"

# run CMD... : execute, or only print if --dry-run. For simple commands
# (no pipe or redirection; for those, test $DRY_RUN by hand).
run() {
  if [ "$DRY_RUN" = 1 ]; then
    printf '    [dry-run] %s\n' "$*"
  else
    "$@"
  fi
}

# log_done MSG : success log; prefixed in dry-run (nothing really happened).
log_done() {
  if [ "$DRY_RUN" = 1 ]; then log_info "[dry-run] $*"; else log_ok "$*"; fi
}

# require_cmd NAME : fail if the command is missing.
require_cmd() {
  command -v "$1" >/dev/null 2>&1 || { log_error "missing command: $1"; return 1; }
}

# run_steps [names...] : run the steps listed in $STEPS (order = $STEPS).
# No name = all. With names = EXACT match (validated upstream by run).
# Each step (setup/steps/<name>.sh) is SOURCED (shares lib + run env).
# Reused by `install` (all / selection) and `update` (subset).
run_steps() {
  : "${STEPS:?STEPS must be set (step order, set by run)}"
  for _short in $STEPS; do
    _f="$DOTFILES_DIR/setup/steps/$_short.sh"
    [ -e "$_f" ] || { log_warn "step not found: $_short.sh"; continue; }
    if [ "$#" -gt 0 ]; then
      _ok=0
      for _flt in "$@"; do [ "$_short" = "$_flt" ] && _ok=1; done
      [ "$_ok" = 1 ] || continue
    fi
    log_step "step: $_short"
    # shellcheck disable=SC1090
    . "$_f"
  done
}

# confirm "Question?" : 0 if yes.
#   --yes       -> yes without asking
#   no TTY      -> no (don't run an irreversible step blindly)
confirm() {
  [ "$ASSUME_YES" = 1 ] && return 0
  # Preview must never block on questions: nothing will be executed anyway.
  [ "$DRY_RUN" = 1 ] && return 0
  # Read/print via /dev/tty (not fd 0): robust if a previous step
  # (brew bundle, curl|sh installers…) consumed or redirected stdin.
  # Accepts STRICTLY y or Y (nothing else): no trailing space or \r tolerated.
  if [ ! -r /dev/tty ]; then
    log_warn "non-interactive without --yes: step skipped ($1)"
    return 1
  fi
  printf '%s [y/N] ' "$1" > /dev/tty
  read -r _ans < /dev/tty || return 1
  case "$_ans" in y|Y) return 0 ;; *) return 1 ;; esac
}

# --- Centralized backups -----------------------------------------------------
# Any moved file (replaced link, migration) goes into ONE directory per run:
#   $XDG_STATE_HOME/dotfiles/backups/<RUN_TS>/<path relative to $HOME>
# Created ON DEMAND: if no backup happens, no directory is created.
: "${RUN_TS:=$(date +%Y%m%d%H%M%S)}"
BACKUP_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles/backups/$RUN_TS"

# backup_file ABS : move ABS into the run's backup directory, preserving
# its path relative to $HOME.
backup_file() {
  _abs=$1
  case "$_abs" in
    "$HOME"/*) _rel=${_abs#"$HOME"/} ;;
    *)         _rel=$(basename "$_abs") ;;
  esac
  _bdest="$BACKUP_DIR/$_rel"
  run mkdir -p "$(dirname "$_bdest")"
  log_done "backup: ${_abs#"$HOME"/} -> ${BACKUP_DIR#"$HOME"/}/$_rel"
  run mv "$_abs" "$_bdest"
}

# migrate_file SRC DST (ABSOLUTE paths) : move a legacy file to its
# location (target computed from XDG variables by the caller). Idempotent:
#   - source missing or already a link -> nothing
#   - target already present           -> don't overwrite; old one goes to backup
# (Logs show paths relative to $HOME when possible.)
migrate_file() {
  _ms=$1; _md=$2
  { [ -e "$_ms" ] && [ ! -L "$_ms" ]; } || return 0
  if [ -e "$_md" ]; then
    log_info "migration: ${_md#"$HOME"/} already exists -> backing up old ${_ms#"$HOME"/}"
    backup_file "$_ms"
    return 0
  fi
  run mkdir -p "$(dirname "$_md")"
  log_done "migrated: ${_ms#"$HOME"/} -> ${_md#"$HOME"/}"
  run mv "$_ms" "$_md"
}

# link_with_backup SRC DST : SRC relative to the repo, DST relative to $HOME.
# Idempotent; backs up an existing real target (centralized) before linking.
link_with_backup() {
  _src="$DOTFILES_DIR/$1"
  _dst="$HOME/$2"
  if [ ! -e "$_src" ]; then
    log_warn "source missing, link skipped: $1"
    return 0
  fi
  # Already the right link? Test by INODE (-ef), not the readlink string: robust
  # to path-form differences (macOS firmlinks /Users vs
  # /System/Volumes/Data/Users, trailing slash, etc.).
  if [ -L "$_dst" ] && [ "$_dst" -ef "$_src" ]; then
    log_ok "already linked: $2"
    return 0
  fi
  if [ -e "$_dst" ] || [ -L "$_dst" ]; then
    backup_file "$_dst"
  fi
  run mkdir -p "$(dirname "$_dst")"
  run ln -sfn "$_src" "$_dst"
  log_done "linked: $2 -> $1"
}
