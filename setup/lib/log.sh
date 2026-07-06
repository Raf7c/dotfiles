#!/usr/bin/env sh
# lib/log.sh — log helpers (POSIX). Colors when output is a terminal
# and NO_COLOR is unset. Sourced by run.

if [ -t 1 ] && [ -z "${NO_COLOR:-}" ]; then
  _c_reset='\033[0m'; _c_red='\033[31m'; _c_yellow='\033[33m'
  _c_green='\033[32m'; _c_blue='\033[34m'; _c_bold='\033[1m'
else
  _c_reset=''; _c_red=''; _c_yellow=''; _c_green=''; _c_blue=''; _c_bold=''
fi

# Failure accounting. Counter FILES (not variables): log_warn/log_error are
# often called inside `… | while` pipelines, i.e. subshells, where a variable
# increment would be lost. $$ is the pid of `run` (unchanged in subshells).
_log_warns="${TMPDIR:-/tmp}/dotfiles-run-$$.warns"
_log_errors="${TMPDIR:-/tmp}/dotfiles-run-$$.errors"

log_step()  { printf '%b==>%b %s\n' "${_c_blue}${_c_bold}" "$_c_reset" "$*"; }
log_info()  { printf '    %s\n' "$*"; }
log_ok()    { printf '%b  ✓ %b%s\n'  "$_c_green"  "$_c_reset" "$*"; }
log_warn()  { printf '%b  ! %b%s\n'  "$_c_yellow" "$_c_reset" "$*" >&2; printf '.\n' >> "$_log_warns"; }
log_error() { printf '%b  ✗ %b%s\n'  "$_c_red"    "$_c_reset" "$*" >&2; printf '.\n' >> "$_log_errors"; }

# log_reset_counts : forget the warnings/errors logged so far (preamble noise).
log_reset_counts() { rm -f -- "$_log_warns" "$_log_errors"; }

# log_summary LABEL : final report; returns 1 if any error was logged, so
# each command can end with an honest exit code (raw printf: the summary
# itself must not increment the counters it reports).
log_summary() {
  _lw=0; _le=0
  [ -f "$_log_warns" ]  && _lw=$(wc -l < "$_log_warns"  | tr -d '[:space:]')
  [ -f "$_log_errors" ] && _le=$(wc -l < "$_log_errors" | tr -d '[:space:]')
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
