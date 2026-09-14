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

# For the fragile commands (network, package managers). Returns 0 on purpose:
# a dead mirror is reported, it does not abort the run.
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

# Terminal line of a step whose failures are reported per ITEM (the manifest
# consumers, brew bundle, mise): $1 on success, $2 when this step logged an
# error. Warnings do NOT suppress the ✓ -- a warning is a deliberate skip, an
# error is a failure. $_step_err0 is the baseline run_steps sets just before
# sourcing the step; :-0 keeps the helper honest if a step is sourced by hand.
log_done_clean() {
  if [ "$(log_errors_count)" != "${_step_err0:-0}" ]; then
    log_info "$2"
    return 0
  fi
  log_done "$1"
}

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || {
    log_error "missing command: $1"
    return 1
  }
}

# No name = all the steps, in $STEPS order. Each step is SOURCED, so it shares
# the libs and run's environment.
run_steps() {
  : "${STEPS:?STEPS must be set (step order, set by run)}"
  # `run` validates the names YOU type; nothing validated the hand-written
  # list in setup/commands/update.sh, where a typo skipped a step in silence.
  for _flt in "$@"; do
    _known=0
    for _s in $STEPS; do [ "$_s" = "$_flt" ] && _known=1; done
    [ "$_known" = 1 ] ||
      log_error "run_steps: unknown step '$_flt' (typo in a command's list?)"
  done
  for _short in $STEPS; do
    if [ "$#" -gt 0 ]; then
      _ok=0
      for _flt in "$@"; do [ "$_short" = "$_flt" ] && _ok=1; done
      [ "$_ok" = 1 ] || continue
    fi
    # AFTER the filter: a step you did not ask for must not make noise. An
    # error, not a warning: exit 0 is how the last botched rename went
    # unnoticed. The CI checks the same pairing both ways, before it ships.
    _f="$DOTFILES_DIR/setup/steps/$_short.sh"
    [ -e "$_f" ] || {
      log_error "step file missing: setup/steps/$_short.sh (STEPS and setup/steps/ disagree)"
      continue
    }
    log_step "step: $_short"
    # The error count as it stands NOW: log_done_clean compares against this
    # baseline, so a step's final ✓ speaks for THAT step and not for the run.
    _step_err0=$(log_errors_count)
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
  if [ "$DRY_RUN" = 1 ]; then
    # Answer yes so the preview shows the full path, but SAY that the real
    # run will ask: an installer that prompts before touching a third-party
    # repo must not hide the prompt in its own preview.
    log_info "[dry-run] would ask: $1"
    return 0
  fi
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

# --- Centralized backups ---
# Everything moved during a run lands in ONE directory, keeping its path
# relative to $HOME. Created on demand. Assertion, not a default: an empty
# RUN_TS would drop every run into backups/, overwriting the previous one.
: "${RUN_TS:?RUN_TS must be set (exported by run)}"
BACKUP_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles/backups/$RUN_TS"

backup_file() {
  _abs=$1
  # An assertion, not a fallback: both callers build under $HOME, and a
  # `basename` fallback would collapse /etc/foo and /var/foo onto one entry.
  case "$_abs" in
    "$HOME"/*) ;;
    *)
      log_error "backup: path outside \$HOME, refused: $_abs"
      return 1
      ;;
  esac
  _rel=${_abs#"$HOME"/}
  _bdest="$BACKUP_DIR/$_rel"
  # Both TESTED, and the failure returned: the caller replaces the original
  # right after, so a ✓ over a backup that did not happen IS data loss.
  run mkdir -p -- "$(dirname -- "$_bdest")" || {
    log_error "backup: cannot create the directory for ${BACKUP_DIR#"$HOME"/}/$_rel"
    return 1
  }
  run mv -- "$_abs" "$_bdest" || {
    log_error "backup FAILED: ${_abs#"$HOME"/} (nothing was moved)"
    return 1
  }
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
    backup_file "$_ms" || return 1
    return 0
  fi
  # Tested, and for a sharper reason than backup_file: migrate runs ONCE per
  # machine, so a migration that failed in green is never replayed.
  run mkdir -p -- "$(dirname -- "$_md")" || {
    log_error "migration: cannot create ${_md%/*}"
    return 1
  }
  run mv -- "$_ms" "$_md" || {
    log_error "migration FAILED: ${_ms#"$HOME"/} stays where it was"
    return 1
  }
  log_done "migrated: ${_ms#"$HOME"/} -> ${_md#"$HOME"/}"
}

# SRC relative to the repo, DST relative to $HOME. Backs up an existing real
# target before linking.
link_with_backup() {
  _src="$DOTFILES_DIR/$1"
  _dst="$HOME/$2"
  if [ ! -e "$_src" ]; then
    # Warn, do not refuse: usually a submodule not yet initialised, and the
    # other links are still worth applying. An installer without per-step
    # accounting would have to stop here instead; this one counts and goes on.
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
  # A pre-existing SYMLINK is backed up too: it records where the old config
  # lived, and the restore path below needs it. Dropping them instead keeps
  # dead links out of the backup directory, at the cost of that information.
  _lbak=''
  if [ -e "$_dst" ] || [ -L "$_dst" ]; then
    # NOT applied if the backup failed: replacing a file whose copy does not
    # exist destroys it, and the restore path below looks for that copy.
    backup_file "$_dst" || {
      log_error "backup failed, link skipped to keep the original: $2"
      return 1
    }
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
