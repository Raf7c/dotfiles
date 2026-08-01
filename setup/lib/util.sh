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
    # Quote each argument: paths with spaces stay unambiguous in the preview.
    printf '    [dry-run]'
    for _a in "$@"; do printf " '%s'" "$_a"; done
    printf '\n'
  else
    "$@"
  fi
}

# run_soft CMD... : like run(), but a FAILURE is logged and swallowed.
# For the fragile commands (network, package managers): a mirror that is
# down, one missing formula or a refused sudo must be reported, not abort
# the whole run through `set -e`. Always returns 0 on purpose.
run_soft() {
  if [ "$DRY_RUN" = 1 ]; then
    run "$@"
    return 0
  fi
  if "$@"; then
    return 0
  fi
  log_error "command failed: $*"
  return 0
}

# log_done MSG : success log; prefixed in dry-run (nothing really happened).
log_done() {
  if [ "$DRY_RUN" = 1 ]; then log_info "[dry-run] $*"; else log_ok "$*"; fi
}

# require_cmd NAME : fail if the command is missing.
require_cmd() {
  command -v "$1" >/dev/null 2>&1 || {
    log_error "missing command: $1"
    return 1
  }
}

# run_steps [names...] : run the steps listed in $STEPS (order = $STEPS).
# No name = all. With names = EXACT match (validated upstream by run).
# Each step (setup/steps/<name>.sh) is SOURCED (shares lib + run env).
# Reused by `install` (all / selection) and `update` (subset).
run_steps() {
  : "${STEPS:?STEPS must be set (step order, set by run)}"
  for _short in $STEPS; do
    _f="$DOTFILES_DIR/setup/steps/$_short.sh"
    [ -e "$_f" ] || {
      log_warn "step not found: $_short.sh"
      continue
    }
    if [ "$#" -gt 0 ]; then
      _ok=0
      for _flt in "$@"; do [ "$_short" = "$_flt" ] && _ok=1; done
      [ "$_ok" = 1 ] || continue
    fi
    log_step "step: $_short"
    # set -e would kill run on any uncaught failure inside a sourced step.
    # Capture the status instead; log_summary owns the final exit code.
    set +e
    # shellcheck disable=SC1090
    . "$_f"
    _rc=$?
    set -e
    [ "$_rc" -eq 0 ] || log_error "step failed: $_short (exit $_rc)"
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
  # -r only tests permission bits, not the presence of a controlling
  # terminal: actually try to OPEN /dev/tty (fails in cron/CI/`ssh host cmd`).
  # Subshell required: a redirection error on a special builtin (:) is FATAL
  # in non-interactive POSIX sh; the subshell absorbs it.
  if ! (: </dev/tty) 2>/dev/null; then
    log_warn "non-interactive without --yes: step skipped ($1)"
    return 1
  fi
  printf '%s [y/N] ' "$1" >/dev/tty
  read -r _ans </dev/tty || return 1
  case "$_ans" in y | Y) return 0 ;; *) return 1 ;; esac
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
    *) _rel=$(basename "$_abs") ;;
  esac
  _bdest="$BACKUP_DIR/$_rel"
  run mkdir -p -- "$(dirname -- "$_bdest")"
  run mv -- "$_abs" "$_bdest"
  log_done "backup: ${_abs#"$HOME"/} -> ${BACKUP_DIR#"$HOME"/}/$_rel"
}

# migrate_file SRC DST (ABSOLUTE paths) : move a legacy file to its
# location (target computed from XDG variables by the caller). Idempotent:
#   - source missing or already a link -> nothing
#   - target already present           -> don't overwrite; old one goes to backup
# (Logs show paths relative to $HOME when possible.)
migrate_file() {
  _ms=$1
  _md=$2
  { [ -e "$_ms" ] && [ ! -L "$_ms" ]; } || return 0
  if [ -e "$_md" ]; then
    log_info "migration: ${_md#"$HOME"/} already exists -> backing up old ${_ms#"$HOME"/}"
    backup_file "$_ms"
    return 0
  fi
  run mkdir -p -- "$(dirname -- "$_md")"
  run mv -- "$_ms" "$_md"
  log_done "migrated: ${_ms#"$HOME"/} -> ${_md#"$HOME"/}"
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
  # shellcheck disable=SC3013  # -ef: extension supported by dash/bash/zsh
  if [ -L "$_dst" ] && [ "$_dst" -ef "$_src" ]; then
    log_ok "already linked: $2"
    return 0
  fi
  # Remember where backup_file moved the target: same rule as backup_file,
  # and $_dst is ALWAYS under $HOME here (built as "$HOME/$2").
  _lbak=''
  if [ -e "$_dst" ] || [ -L "$_dst" ]; then
    backup_file "$_dst"
    _lbak="$BACKUP_DIR/${_dst#"$HOME"/}"
  fi
  run mkdir -p -- "$(dirname -- "$_dst")"
  # `ln` CAN fail after the backup (read-only parent, ENOSPC, immutable
  # flag...). Leaving the user with neither the original nor the link is
  # the worst outcome: put the backup back and report the failure.
  if run ln -sfn -- "$_src" "$_dst"; then
    log_done "linked: $2 -> $1"
    return 0
  fi
  log_error "link failed: $2 -> $1"
  if [ -n "$_lbak" ] && [ -e "$_lbak" ]; then
    if run mv -- "$_lbak" "$_dst"; then
      log_info "original restored: $2"
    else
      log_error "restore failed, the original stays in ${_lbak#"$HOME"/}"
    fi
  fi
  return 1
}
