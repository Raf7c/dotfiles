#!/usr/bin/env sh
# lib/log.sh — log helpers (POSIX). Colors when output is a terminal
# and NO_COLOR is unset. Sourced by run.

if [ -t 1 ] && [ -z "${NO_COLOR:-}" ]; then
  _c_reset='\033[0m'; _c_red='\033[31m'; _c_yellow='\033[33m'
  _c_green='\033[32m'; _c_blue='\033[34m'; _c_bold='\033[1m'
else
  _c_reset=''; _c_red=''; _c_yellow=''; _c_green=''; _c_blue=''; _c_bold=''
fi

log_step()  { printf '%b==>%b %s\n' "${_c_blue}${_c_bold}" "$_c_reset" "$*"; }
log_info()  { printf '    %s\n' "$*"; }
log_ok()    { printf '%b  ✓ %b%s\n'  "$_c_green"  "$_c_reset" "$*"; }
log_warn()  { printf '%b  ! %b%s\n'  "$_c_yellow" "$_c_reset" "$*" >&2; }
log_error() { printf '%b  ✗ %b%s\n'  "$_c_red"    "$_c_reset" "$*" >&2; }
