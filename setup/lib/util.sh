#!/usr/bin/env sh
# lib/util.sh: general helpers (POSIX). Depends on log.sh (already sourced).
# The DRY_RUN / ASSUME_YES flags and DOTFILES_DIR are set by run.

: "${DOTFILES_DIR:?DOTFILES_DIR must be set}"

# Simple commands only: for a pipe or a redirection, test $DRY_RUN by hand.
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

# For the fragile commands (network, package managers): a dead mirror must be
# reported, not abort the whole run through `set -e`. Returns 0 on purpose.
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

# Success log, prefixed in dry-run: nothing really happened.
log_done() {
  if [ "$DRY_RUN" = 1 ]; then log_info "[dry-run] $*"; else log_ok "$*"; fi
}

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || {
    log_error "missing command: $1"
    return 1
  }
}

# No name = all the steps, in $STEPS order. With names = EXACT match (validated
# by run). Each step is SOURCED, so it shares the libs and run's environment.
run_steps() {
  : "${STEPS:?STEPS must be set (step order, set by run)}"
  # A filter name matching no step is silently dropped by the loop below. `run`
  # validates the names YOU type; nothing validated the hand-written list of
  # setup/commands/update.sh, so a typo there skipped a step without a word.
  for _flt in "$@"; do
    _known=0
    for _s in $STEPS; do [ "$_s" = "$_flt" ] && _known=1; done
    [ "$_known" = 1 ] ||
      log_error "run_steps: unknown step '$_flt' (typo in a command's list?)"
  done
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

# 0 if yes. --yes answers yes, no TTY answers no: an irreversible step must
# never run blindly.
confirm() {
  [ "$ASSUME_YES" = 1 ] && return 0
  [ "$DRY_RUN" = 1 ] && return 0
  # /dev/tty, not fd 0: a previous step (brew bundle, curl|sh) may have eaten
  # stdin. -r would only test permission bits, so actually OPEN the device;
  # the subshell is required because a redirection error on a special builtin
  # is FATAL in non-interactive POSIX sh.
  if ! (: </dev/tty) 2>/dev/null; then
    log_warn "non-interactive without --yes: step skipped ($1)"
    return 1
  fi
  printf '%s [y/N] ' "$1" >/dev/tty
  read -r _ans </dev/tty || return 1
  case "$_ans" in y | Y) return 0 ;; *) return 1 ;; esac
}

# --- Centralized backups -----------------------------------------------------
# Everything moved during a run lands in ONE directory, keeping its path
# relative to $HOME. Created on demand: no backup, no directory.
# Assertion, not a default: an empty RUN_TS would drop every run's backups
# straight into backups/, where successive runs would overwrite each other.
: "${RUN_TS:?RUN_TS must be set (exported by run)}"
BACKUP_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles/backups/$RUN_TS"

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

# Both paths ABSOLUTE. No-op if the source is missing or is already a symlink.
# If the target exists nothing is overwritten: the legacy source goes to the
# backup directory instead.
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

# SRC relative to the repo, DST relative to $HOME. Backs up an existing real
# target before linking.
link_with_backup() {
  _src="$DOTFILES_DIR/$1"
  _dst="$HOME/$2"
  if [ ! -e "$_src" ]; then
    log_warn "source missing, link skipped: $1"
    return 0
  fi
  # Compare by INODE, not by readlink string: macOS firmlinks make /Users and
  # /System/Volumes/Data/Users two spellings of the same path.
  # shellcheck disable=SC3013  # -ef: extension supported by dash/bash/zsh
  if [ -L "$_dst" ] && [ "$_dst" -ef "$_src" ]; then
    log_ok "already linked: $2"
    return 0
  fi
  # Where backup_file will have moved it ($_dst is always under $HOME here).
  # A pre-existing SYMLINK is backed up too, not deleted: it records where the
  # old config lived, and the restore-on-failure path below needs it. The school
  # repo deliberately does the opposite (it drops dead links instead) — the two
  # repos are independent and each states its choice.
  _lbak=''
  if [ -e "$_dst" ] || [ -L "$_dst" ]; then
    backup_file "$_dst"
    _lbak="$BACKUP_DIR/${_dst#"$HOME"/}"
  fi
  run mkdir -p -- "$(dirname -- "$_dst")"
  # `ln` can still fail after the backup (read-only parent, ENOSPC). Leaving
  # neither the original nor the link is the worst outcome: restore and report.
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
