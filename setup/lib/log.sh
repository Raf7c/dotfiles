#!/usr/bin/env sh
# lib/log.sh: log helpers (POSIX). Colors when output is a terminal
# and NO_COLOR is unset. Sourced by run.

if [ -t 1 ] && [ -z "${NO_COLOR:-}" ]; then
  _c_reset='\033[0m'
  _c_red='\033[31m'
  _c_yellow='\033[33m'
  _c_green='\033[32m'
  _c_blue='\033[34m'
  _c_bold='\033[1m'
else
  _c_reset=''
  _c_red=''
  _c_yellow=''
  _c_green=''
  _c_blue=''
  _c_bold=''
fi

# Failure accounting in FILES, not variables: log_warn/log_error are often
# called inside `… | while` pipelines, i.e. subshells, where an increment would
# be lost. They live in a private mktemp -d directory (0700, unpredictable
# name): a $$-derived name in a world-writable /tmp can be pre-created as a
# symlink by another user. Traps remove it on every exit path.
_log_dir=$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-run.XXXXXX") || {
  printf 'log.sh: cannot create the temporary directory\n' >&2
  exit 1
}
_log_warns="$_log_dir/warns"
_log_errors="$_log_dir/errors"

log_cleanup() { rm -rf -- "$_log_dir"; }
# INT/TERM exit with the conventional 128+signal code: on some shells the EXIT
# trap would otherwise be the only one to fire.
trap 'log_cleanup' EXIT
trap 'log_cleanup; exit 130' INT
trap 'log_cleanup; exit 143' TERM

log_step() { printf '%b==>%b %s\n' "${_c_blue}${_c_bold}" "$_c_reset" "$*"; }
log_info() { printf '    %s\n' "$*"; }
log_ok() { printf '%b  ✓ %b%s\n' "$_c_green" "$_c_reset" "$*"; }
log_warn() {
  printf '%b  ! %b%s\n' "$_c_yellow" "$_c_reset" "$*" >&2
  printf '.\n' >>"$_log_warns"
}
log_error() {
  printf '%b  ✗ %b%s\n' "$_c_red" "$_c_reset" "$*" >&2
  printf '.\n' >>"$_log_errors"
}

# Forget what was logged so far (preamble noise).
log_reset_counts() { rm -f -- "$_log_warns" "$_log_errors"; }

# Returns 1 if any error was logged, so each command ends with an honest exit
# code. Raw printf: the summary must not increment the counters it reports.
log_summary() {
  _lw=0
  _le=0
  [ -f "$_log_warns" ] && _lw=$(wc -l <"$_log_warns" | tr -d '[:space:]')
  [ -f "$_log_errors" ] && _le=$(wc -l <"$_log_errors" | tr -d '[:space:]')
  log_reset_counts
  if [ "$_le" -gt 0 ]; then
    printf '%b  ✗ %b%s\n' "$_c_red" "$_c_reset" "$1: $_le error(s), $_lw warning(s)" >&2
    return 1
  fi
  if [ "$_lw" -gt 0 ]; then
    printf '%b  ! %b%s\n' "$_c_yellow" "$_c_reset" "$1: $_lw warning(s)" >&2
  fi
  return 0
}
