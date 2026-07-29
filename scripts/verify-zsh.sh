#!/usr/bin/env sh
# verify-zsh.sh — non-executable zsh checks, for the audit sandbox.
# Read only: modifies no file. Run it on macOS AND on Fedora.
set -eu

DOT="${DOTFILES:-$HOME/.dotfiles}"
ZDIR="$DOT/.config/zsh"
_fail=0

printf '== 1. Syntax (zsh -n) ==\n'
for _f in "$ZDIR/.zshenv" "$ZDIR/.zprofile" "$ZDIR/.zshrc" \
  "$ZDIR/zinit.zsh" "$ZDIR/fzf.zsh"; do
  if zsh -n -- "$_f" 2>/tmp/zsyn.$$; then
    printf 'OK   %s\n' "$_f"
  else
    printf 'FAIL %s\n' "$_f"; cat /tmp/zsyn.$$; _fail=1
  fi
done
rm -f -- /tmp/zsyn.$$

printf '\n== 2. Cold start: stderr MUST be empty ==\n'
for _mode in "-i" "-l -i"; do
  # shellcheck disable=SC2086
  zsh $_mode -c exit 2>/tmp/zerr.$$ || true
  if [ -s /tmp/zerr.$$ ]; then
    printf 'FAIL zsh %s -c exit — stderr:\n' "$_mode"; cat /tmp/zerr.$$; _fail=1
  else
    printf 'OK   zsh %s -c exit (empty stderr)\n' "$_mode"
  fi
done
rm -f -- /tmp/zerr.$$

printf '\n== 3. Startup time (x10) ==\n'
_i=0
while [ "$_i" -lt 10 ]; do
  _t0=$(date +%s%N 2>/dev/null || gdate +%s%N)
  zsh -i -c exit
  _t1=$(date +%s%N 2>/dev/null || gdate +%s%N)
  printf '  run %d: %d ms\n' "$((_i + 1))" "$(((_t1 - _t0) / 1000000))"
  _i=$((_i + 1))
done

printf '\n== 4. zprof profile (top 15) ==\n'
zsh -i -c 'zmodload zsh/zprof >/dev/null 2>&1; source "$ZDOTDIR/.zshrc" 2>/dev/null; zprof' \
  2>/dev/null | head -20 || printf '  (zprof unavailable)\n'

printf '\n== 5. Optional tools ==\n'
if command -v shellcheck >/dev/null 2>&1; then
  shellcheck -s sh -- "$DOT/run" "$DOT"/setup/lib/*.sh "$DOT"/setup/steps/*.sh \
    "$DOT"/setup/commands/*.sh "$DOT/setup/manifest.sh" \
    "$DOT"/.config/shell/*.sh || _fail=1
else
  printf '  shellcheck missing (brew install shellcheck / dnf install ShellCheck)\n'
fi
if command -v checkbashisms >/dev/null 2>&1; then
  checkbashisms -- "$DOT/run" "$DOT"/setup/lib/*.sh "$DOT"/setup/steps/*.sh \
    "$DOT"/setup/commands/*.sh "$DOT"/.config/shell/*.sh || _fail=1
else
  printf '  checkbashisms missing (brew install checkbashisms / dnf install devscripts-checkbashisms)\n'
fi

printf '\n== 6. ZDOTDIR bootstrap ==\n'
# Since the /etc route was dropped, ~/.zshenv IS the bootstrap: it must exist
# and point at this repo.
if [ -r "$HOME/.zshenv" ]; then
  printf '  OK   ~/.zshenv present\n'
  # shellcheck disable=SC3013  # -ef: extension supported by dash/bash/zsh
  if [ "$HOME/.zshenv" -ef "$DOT/.zshenv" ]; then
    printf '  OK   ~/.zshenv -> the repo\n'
  else
    printf '  FAIL ~/.zshenv exists but is NOT the repo file\n'
    _fail=1
  fi
else
  printf '  FAIL ~/.zshenv missing: the zsh config will not load\n'
  _fail=1
fi
# A leftover block from the old sudo-based bootstrap is harmless but redundant,
# and it makes `zsh -f` inherit ZDOTDIR. Report it, do not fail.
_n=$(grep -c -- 'dotfiles ZDOTDIR' /etc/zshenv 2>/dev/null || printf '0')
if [ "$_n" != 0 ]; then
  printf '  WARN /etc/zshenv still carries the old ZDOTDIR block -> remove it\n'
fi

if [ "$_fail" = 0 ]; then
  printf '\nRESULT: OK\n'
else
  printf '\nRESULT: FAILURES above\n'
  exit 1
fi
