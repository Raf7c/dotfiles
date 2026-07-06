#!/usr/bin/env sh
# verify-zsh.sh — checks zsh non exécutables dans le sandbox d'audit.
# Lecture seule : ne modifie aucun fichier. À lancer sur macOS ET Fedora.
set -eu

DOT="${DOTFILES:-$HOME/.dotfiles}"
ZDIR="$DOT/.config/zsh"
_fail=0

printf '== 1. Syntaxe (zsh -n) ==\n'
for _f in "$ZDIR/.zshenv" "$ZDIR/.zprofile" "$ZDIR/.zshrc" \
  "$ZDIR/zinit.zsh" "$ZDIR/fzf.zsh"; do
  if zsh -n -- "$_f" 2>/tmp/zsyn.$$; then
    printf 'OK   %s\n' "$_f"
  else
    printf 'FAIL %s\n' "$_f"; cat /tmp/zsyn.$$; _fail=1
  fi
done
rm -f /tmp/zsyn.$$

printf '\n== 2. Demarrage a froid : stderr doit etre VIDE ==\n'
for _mode in "-i" "-l -i"; do
  # shellcheck disable=SC2086
  zsh $_mode -c exit 2>/tmp/zerr.$$ || true
  if [ -s /tmp/zerr.$$ ]; then
    printf 'FAIL zsh %s -c exit — stderr:\n' "$_mode"; cat /tmp/zerr.$$; _fail=1
  else
    printf 'OK   zsh %s -c exit (stderr vide)\n' "$_mode"
  fi
done
rm -f /tmp/zerr.$$

printf '\n== 3. Temps de demarrage (x10) ==\n'
_i=0
while [ "$_i" -lt 10 ]; do
  _t0=$(date +%s%N 2>/dev/null || gdate +%s%N)
  zsh -i -c exit
  _t1=$(date +%s%N 2>/dev/null || gdate +%s%N)
  printf '  run %d: %d ms\n' "$((_i + 1))" "$(((_t1 - _t0) / 1000000))"
  _i=$((_i + 1))
done

printf '\n== 4. Profil zprof (top 15) ==\n'
zsh -i -c 'zmodload zsh/zprof >/dev/null 2>&1; source "$ZDOTDIR/.zshrc" 2>/dev/null; zprof' \
  2>/dev/null | head -20 || printf '  (zprof indisponible)\n'

printf '\n== 5. Outils optionnels ==\n'
if command -v shellcheck >/dev/null 2>&1; then
  shellcheck -s sh -- "$DOT/run" "$DOT"/setup/lib/*.sh "$DOT"/setup/steps/*.sh \
    "$DOT"/setup/commands/*.sh "$DOT/setup/manifest.sh" \
    "$DOT"/.config/shell/*.sh || _fail=1
else
  printf '  shellcheck absent (brew install shellcheck / dnf install ShellCheck)\n'
fi
if command -v checkbashisms >/dev/null 2>&1; then
  checkbashisms -- "$DOT/run" "$DOT"/setup/lib/*.sh "$DOT"/setup/steps/*.sh \
    "$DOT"/setup/commands/*.sh "$DOT"/.config/shell/*.sh || _fail=1
else
  printf '  checkbashisms absent (brew install checkbashisms / dnf install devscripts-checkbashisms)\n'
fi

printf '\n== 6. /etc/zshenv : bloc ZDOTDIR present une seule fois ==\n'
_n=$(grep -c 'dotfiles ZDOTDIR' /etc/zshenv 2>/dev/null || printf '0')
printf '  occurrences du marqueur: %s (attendu: 2 — debut+fin)\n' "$_n"

[ "$_fail" = 0 ] && printf '\nRESULTAT: OK\n' || { printf '\nRESULTAT: ECHECS ci-dessus\n'; exit 1; }
