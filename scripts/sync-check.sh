#!/usr/bin/env sh
# sync-check.sh verifies the cross-repo contract: files both dotfiles repos
# promise to keep byte-identical. Read-only. Usage:
#   sync-check.sh [path-to-school-repo]
set -eu

DOT="${DOTFILES:-$HOME/.dotfiles}"
[ -e "$DOT/run" ] || {
  printf 'not a dotfiles repo: %s (set DOTFILES)\n' "$DOT" >&2
  exit 2
}
SCHOOL="${1:-}"
if [ -z "$SCHOOL" ]; then
  for _c in "$HOME/dotifiles42" "$HOME/lab/github/dotifiles42"; do
    [ -d "$_c" ] && SCHOOL="$_c" && break
  done
fi
[ -d "${SCHOOL:-}" ] || {
  printf 'school repo not found, pass its path as argument\n' >&2
  exit 2
}

# The contract list. kitty.conf included: its header is written to be true
# in both repos on purpose.
set -- \
  .config/kitty/kitty.conf \
  .config/kitty/light-theme.auto.conf \
  .config/kitty/dark-theme.auto.conf \
  .config/kitty/no-preference-theme.auto.conf \
  .config/kitty/themes/latte.conf \
  .config/kitty/themes/mocha.conf \
  .config/tmux/themes/latte.conf \
  .config/tmux/themes/mocha.conf \
  .gitmodules
# Known, DELIBERATE divergences kept out of the list:
#   .config/git/ignore   (the claude line is personal-repo only)
#   .editorconfig        (same rules, different section order)
#   .config/tmux/tmux.conf (identical logic; two comments carry per-repo
#                           truths: who guarantees the copy tools, RAM note)

_fail=0
for _f in "$@"; do
  if cmp -s -- "$DOT/$_f" "$SCHOOL/$_f" 2>/dev/null; then
    printf 'OK   %s\n' "$_f"
  else
    printf 'DIFF %s\n' "$_f"
    _fail=1
  fi
done
[ "$_fail" -eq 0 ] && printf 'contract held: all shared files identical\n'
exit "$_fail"
