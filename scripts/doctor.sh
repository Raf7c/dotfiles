#!/usr/bin/env sh
# shellcheck disable=SC2088  # "~/..." in messages is display text, never expanded
# doctor.sh — read-only health checks for the whole configuration.
#
# Same pattern as `brew doctor` / nvim `:checkhealth`: every check prints
# OK / WARN / FAIL with the suggested fix, nothing is ever modified, and the
# exit code is 1 as soon as one check FAILs. Run it on macOS AND on Fedora.
#
# Usage:
#   doctor.sh                  all sections
#   doctor.sh env aliases      only those sections
#
# Sections: shells bootstrap env path links aliases mise plugins lint
set -u

DOT="${DOTFILES:-$HOME/.dotfiles}"
ZDIR="$DOT/.config/zsh"
ALL="shells bootstrap env path links aliases mise plugins lint"

_ok=0
_warn=0
_fail=0
ok() {
  printf '  OK   %s\n' "$1"
  _ok=$((_ok + 1))
}
warn() {
  printf '  WARN %s\n' "$1"
  _warn=$((_warn + 1))
}
fail() {
  printf '  FAIL %s\n' "$1"
  _fail=$((_fail + 1))
}
info() { printf '  ---  %s\n' "$1"; }
section() { printf '\n== %s ==\n' "$1"; }

has() { command -v -- "$1" >/dev/null 2>&1; }

# ---------------------------------------------------------------- shells ---
# Syntax, cold start (stderr must stay empty: the "degrades cleanly" claim
# is checked here, not assumed), startup time, zprof hotspots.
sec_shells() {
  section "shells: syntax"
  for _f in "$ZDIR/.zshenv" "$ZDIR/.zprofile" "$ZDIR/.zshrc" \
    "$ZDIR/zinit.zsh" "$ZDIR/fzf.zsh"; do
    if zsh -n -- "$_f" 2>/dev/null; then
      ok "zsh -n ${_f##*/}"
    else
      fail "zsh -n ${_f##*/}"
    fi
  done
  for _f in "$DOT/.bashrc" "$DOT/.bash_profile"; do
    if bash -n -- "$_f" 2>/dev/null; then
      ok "bash -n ${_f##*/}"
    else
      fail "bash -n ${_f##*/}"
    fi
  done

  section "shells: cold start (stderr must be empty)"
  for _cmd in "zsh -i" "zsh -l -i" "bash -i"; do
    # shellcheck disable=SC2086
    $_cmd -c exit 2>"/tmp/doctor.$$" || true
    # An interactive bash echoes "exit" when it terminates: that is bash
    # itself, not the configuration — anything MORE than that is a failure.
    if [ ! -s "/tmp/doctor.$$" ] || [ "$(cat "/tmp/doctor.$$")" = "exit" ]; then
      ok "$_cmd -c exit"
    else
      fail "$_cmd -c exit — stderr:"
      sed 's/^/       /' "/tmp/doctor.$$"
    fi
  done
  rm -f -- "/tmp/doctor.$$"

  section "shells: startup time (median of 10, WARN over 200 ms)"
  # BSD date has no %N and prints a literal N instead of failing: probe the
  # output, not the exit code.
  _date='date'
  case "$(date +%s%N)" in *N*)
    if has gdate; then _date=gdate; else
      info "no ns-precision date (brew install coreutils) -> timing skipped"
      _date=''
    fi
    ;;
  esac
  if has hyperfine; then
    # hyperfine is the community benchmark tool: warmup + outlier handling
    # beat the loop below whenever it is installed.
    hyperfine --warmup 2 'zsh -i -c exit' 'bash -i -c exit' 2>/dev/null |
      sed 's/^/  /'
  elif [ -n "$_date" ]; then
    for _sh in zsh bash; do
      _i=0
      : >"/tmp/doctor.$$"
      while [ "$_i" -lt 10 ]; do
        _t0=$("$_date" +%s%N)
        "$_sh" -i -c exit 2>/dev/null
        _t1=$("$_date" +%s%N)
        printf '%d\n' "$(((_t1 - _t0) / 1000000))" >>"/tmp/doctor.$$"
        _i=$((_i + 1))
      done
      _med=$(sort -n "/tmp/doctor.$$" | sed -n '5p')
      if [ "$_med" -gt 200 ]; then
        warn "$_sh: ${_med} ms median -> profile below (zsh) or bisect .bashrc"
      else
        ok "$_sh: ${_med} ms median"
      fi
    done
    rm -f -- "/tmp/doctor.$$"
  fi

  section "shells: zsh profile (zprof top 12)"
  zsh -i -c 'zmodload zsh/zprof >/dev/null 2>&1
    source "$ZDOTDIR/.zshrc" 2>/dev/null; zprof' 2>/dev/null |
    head -15 | sed 's/^/  /' || info "zprof unavailable"
  info "bash has no zprof equivalent -> if slow, bisect .bashrc by hand"
}

# ------------------------------------------------------------- bootstrap ---
sec_bootstrap() {
  section "bootstrap: ZDOTDIR without root"
  if [ -r "$HOME/.zshenv" ]; then
    # shellcheck disable=SC3013  # -ef: supported by dash/bash/zsh
    if [ "$HOME/.zshenv" -ef "$DOT/.zshenv" ]; then
      ok "~/.zshenv -> the repo"
    else
      fail "~/.zshenv exists but is NOT the repo file -> ./run install symlinks"
    fi
  else
    fail "~/.zshenv missing: the zsh config will not load -> ./run install symlinks"
  fi
  # Leftover from the old sudo-based bootstrap: harmless but redundant, and
  # it makes `zsh -f` inherit ZDOTDIR.
  if grep -q -- 'dotfiles ZDOTDIR' /etc/zshenv 2>/dev/null; then
    warn "/etc/zshenv still carries the old ZDOTDIR block -> remove it"
  fi
}

# ------------------------------------------------------------------- env ---
# Asked to a REAL interactive shell, not recomputed here: the point is to
# see what each shell actually gets, not what env.sh intends. Both shells
# are dumped, then compared: env.sh claims to be their single source of
# truth, so the shared variables must be identical.
_env_dump() {
  # shellcheck disable=SC2016  # expansion must happen in the TARGET shell
  "$1" -i -c 'printf "%s\n" "EDITOR=$EDITOR" "LANG=$LANG" \
    "XDG_CONFIG_HOME=$XDG_CONFIG_HOME" "XDG_STATE_HOME=$XDG_STATE_HOME" \
    "XDG_CACHE_HOME=$XDG_CACHE_HOME" "XDG_DATA_HOME=$XDG_DATA_HOME" \
    "GITUSER=$GITUSER" "REPOS=$REPOS" "HISTFILE=$HISTFILE"' \
    2>/dev/null >"$2" || true
}

sec_env() {
  for _shell in zsh bash; do
    section "env: as seen by an interactive $_shell"
    _env_dump "$_shell" "/tmp/doctor.$$.$_shell"
    # while < file, not a pipe: a pipe would run the loop in a subshell and
    # silently drop every counter increment.
    while IFS= read -r _kv; do
      _k=${_kv%%=*}
      _v=${_kv#*=}
      if [ -z "$_v" ]; then
        fail "$_k is empty in $_shell -> env.sh not loaded?"
      else
        ok "$_k=$_v"
      fi
    done <"/tmp/doctor.$$.$_shell"
  done

  section "env: zsh/bash coherence (env.sh single source of truth)"
  # HISTFILE is per-shell by design; everything else must match.
  grep -v '^HISTFILE=' "/tmp/doctor.$$.zsh" >"/tmp/doctor.$$.a"
  grep -v '^HISTFILE=' "/tmp/doctor.$$.bash" >"/tmp/doctor.$$.b"
  if diff -- "/tmp/doctor.$$.a" "/tmp/doctor.$$.b" >"/tmp/doctor.$$.d" 2>&1; then
    ok "shared variables identical in both shells"
  else
    fail "shared variables diverge between zsh and bash:"
    sed 's/^/       /' "/tmp/doctor.$$.d"
  fi
  rm -f -- "/tmp/doctor.$$.a" "/tmp/doctor.$$.d"

  _ed=$(sed -n 's/^EDITOR=//p' "/tmp/doctor.$$.zsh")
  if [ -n "$_ed" ] && ! has "$_ed"; then
    fail "EDITOR=$_ed does not resolve -> mise install / dnf install"
  fi

  section "env: history (per shell)"
  for _shell in zsh bash; do
    _hf=$(sed -n 's/^HISTFILE=//p' "/tmp/doctor.$$.$_shell")
    if [ -n "$_hf" ]; then
      _hd=${_hf%/*}
      if [ -d "$_hd" ] && [ -w "$_hd" ]; then
        ok "$_shell HISTFILE directory writable ($_hd)"
      else
        fail "$_shell HISTFILE directory missing or read-only ($_hd) -> history is being lost"
      fi
    fi
  done
  rm -f -- "/tmp/doctor.$$.zsh" "/tmp/doctor.$$.bash" "/tmp/doctor.$$.b"
  # Legacy files back at the root: migrate runs ONCE per machine, so a file
  # here was recreated afterwards — by a shell started without this config
  # (bash --norc, a tool spawning `sh`) or a program ignoring HISTFILE.
  # Rerunning migrate would not help; find the writer, then merge/delete.
  for _legacy in .zsh_history .bash_history .lesshst .python_history; do
    [ -e "$HOME/$_legacy" ] && warn "~/$_legacy present -> something recreated it; merge/delete by hand"
  done
  return 0
}

# ------------------------------------------------------------------ path ---
sec_path() {
  for _shell in zsh bash; do
    section "path: $_shell — order, duplicates, dead entries"
    if [ "$_shell" = zsh ]; then
      zsh -i -c 'print -rl -- $path' 2>/dev/null >"/tmp/doctor.$$" || true
    else
      bash -i -c 'printf "%s\n" "$PATH" | tr ":" "\n"' 2>/dev/null >"/tmp/doctor.$$" || true
    fi
    if [ ! -s "/tmp/doctor.$$" ]; then
      info "could not read PATH from an interactive $_shell"
      continue
    fi
    case "$(head -1 "/tmp/doctor.$$")" in
      */mise/shims) ok "mise shims first in PATH" ;;
      *) warn "mise shims are not first -> runtime versions may come from the OS" ;;
    esac
    _dup=$(sort "/tmp/doctor.$$" | uniq -d)
    if [ -n "$_dup" ]; then
      warn "duplicated PATH entries: $(printf '%s' "$_dup" | tr '\n' ' ')"
    else
      ok "no duplicated entries"
    fi
    _dead=0
    while IFS= read -r _p; do
      [ -d "$_p" ] || _dead=$((_dead + 1))
    done <"/tmp/doctor.$$"
    if [ "$_dead" -gt 0 ]; then
      warn "$_dead PATH entries do not exist (harmless, but noise)"
    else
      ok "every PATH entry exists"
    fi
    rm -f -- "/tmp/doctor.$$"
  done
}

# ----------------------------------------------------------------- links ---
# The manifest is the source of truth: make it work here too.
sec_links() {
  section "links: manifest vs \$HOME"
  # shellcheck disable=SC1091
  . "$DOT/setup/manifest.sh"
  dotfiles_links >"/tmp/doctor.$$"
  while IFS= read -r _line; do
    case "$_line" in '' | \#*) continue ;; esac
    _src=$DOT/${_line%% *}
    _dst=$HOME/${_line##* }
    # shellcheck disable=SC3013  # -ef: supported by dash/bash/zsh
    if [ ! -e "$_dst" ]; then
      fail "missing: ~/${_line##* } -> ./run install symlinks"
    elif [ "$_dst" -ef "$_src" ]; then
      ok "~/${_line##* }"
    else
      fail "~/${_line##* } does not point into the repo"
    fi
  done <"/tmp/doctor.$$"
  rm -f -- "/tmp/doctor.$$"
}

# --------------------------------------------------------------- aliases ---
# Asked to the interactive shell itself: aliases.sh guards its definitions
# with `command -v`, so parsing the file would flag fallbacks that never ran.
sec_aliases() {
  section "aliases: every target resolves (zsh)"
  # _ws must be a REAL array: on a one-word alias, ${${(z)...}[1]} collapses
  # to a scalar and [1] indexes characters ("nvim" -> "n").
  zsh -i -c '
    local -a _ws
    for _k in ${(k)aliases}; do
      _ws=( ${(z)aliases[$_k]} )
      _w=$_ws[1]
      (( $+aliases[$_w] )) && continue
      whence -- $_w >/dev/null 2>&1 || print -r -- "$_k -> $_w"
    done' 2>/dev/null >"/tmp/doctor.$$" || true
  if [ -s "/tmp/doctor.$$" ]; then
    while IFS= read -r _m; do
      warn "alias $_m: target not found"
    done <"/tmp/doctor.$$"
  else
    ok "all zsh aliases resolve"
  fi

  section "aliases: every target resolves (bash)"
  bash -i -c '
    for _k in "${!BASH_ALIASES[@]}"; do
      _t=${BASH_ALIASES[$_k]}
      _w=${_t%%[[:space:]]*}
      [ -n "${BASH_ALIASES[$_w]+x}" ] && continue
      command -v -- "$_w" >/dev/null 2>&1 || printf "%s -> %s\n" "$_k" "$_w"
    done' 2>/dev/null >"/tmp/doctor.$$" || true
  if [ -s "/tmp/doctor.$$" ]; then
    while IFS= read -r _m; do
      warn "alias $_m: target not found"
    done <"/tmp/doctor.$$"
  else
    ok "all bash aliases resolve"
  fi
  rm -f -- "/tmp/doctor.$$"
}

# ------------------------------------------------------------------ mise ---
sec_mise() {
  section "mise: runtimes"
  if ! has mise; then
    fail "mise missing -> ./run install packages"
    return 0
  fi
  ok "mise present ($(mise --version 2>/dev/null | head -1))"
  if _missing=$(mise ls --missing 2>/dev/null); then
    if [ -n "$_missing" ]; then
      warn "runtimes declared but not installed -> mise install"
      printf '%s\n' "$_missing" | sed 's/^/       /'
    else
      ok "every declared runtime is installed"
    fi
  else
    info "this mise has no 'ls --missing' -> mise doctor"
  fi
  if [ -d "${XDG_DATA_HOME:-$HOME/.local/share}/mise/shims" ]; then
    ok "shims directory present"
  else
    warn "no shims directory -> mise reshim"
  fi
}

# --------------------------------------------------------------- plugins ---
sec_plugins() {
  section "plugins: zinit, compdump, TPM"
  _zhome="${XDG_DATA_HOME:-$HOME/.local/share}/zinit"
  if [ -r "$_zhome/zinit.git/zinit.zsh" ]; then
    ok "zinit cloned"
  else
    warn "zinit not cloned -> next interactive zsh will fetch it (needs network)"
  fi
  # Orphans: still on disk, no longer declared — the unpinned-by-policy
  # model relies on this list staying empty (see docs/architecture.md).
  if [ -d "$_zhome/plugins" ]; then
    for _d in "$_zhome/plugins"/*; do
      [ -d "$_d" ] || continue
      _name=${_d##*/}
      [ "$_name" = "_local---zinit" ] && continue
      _repo=$(printf '%s' "$_name" | sed 's|---|/|')
      grep -q -- "$_repo" "$ZDIR/zinit.zsh" ||
        warn "orphan plugin on disk: $_repo -> rm -rf '$_d'"
    done
  fi
  # $HOST as zsh sees it, not `hostname -s`: zinit.zsh names the dump with
  # $HOST, and the two differ on macOS (.local suffix).
  _dump="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-$(zsh -c 'printf %s $HOST' 2>/dev/null)-$(zsh -c 'printf %s $ZSH_VERSION' 2>/dev/null)"
  if [ -f "$_dump" ]; then
    ok "compinit dump for this host+zsh version"
  else
    warn "no compinit dump yet (first interactive zsh will create it)"
  fi
  if [ -d "$DOT/.config/tmux/plugins/tpm" ]; then
    ok "TPM present"
  else
    warn "TPM missing -> ./run install plugins"
  fi
}

# ------------------------------------------------------------------ lint ---
sec_lint() {
  section "lint: shellcheck + shfmt (the formatting authority)"
  if has shellcheck; then
    # -S warning: SC1091 (info) fires on every runtime-resolved `. $VAR/...`
    # and cannot be helped; the health bar here is warning and above.
    if shellcheck -S warning -- "$DOT/run" "$DOT"/setup/lib/*.sh "$DOT"/setup/steps/*.sh \
      "$DOT"/setup/commands/*.sh "$DOT/setup/manifest.sh" \
      "$DOT"/.config/shell/*.sh "$DOT"/scripts/*.sh; then
      ok "shellcheck clean"
    else
      fail "shellcheck findings above"
    fi
  else
    info "shellcheck missing (brew install shellcheck / dnf install ShellCheck)"
  fi
  if has shfmt; then
    if shfmt -d -- "$DOT/run" "$DOT"/setup "$DOT"/.config/shell "$DOT"/scripts; then
      ok "shfmt clean"
    else
      fail "shfmt divergence above (.editorconfig is the authority)"
    fi
  else
    info "shfmt missing (brew install shfmt / dnf install shfmt)"
  fi
  if has checkbashisms; then
    if checkbashisms -- "$DOT/run" "$DOT"/setup/lib/*.sh "$DOT"/setup/steps/*.sh \
      "$DOT"/setup/commands/*.sh "$DOT"/.config/shell/*.sh 2>/dev/null; then
      ok "checkbashisms clean"
    else
      fail "bashisms above"
    fi
  else
    info "checkbashisms missing (brew install checkbashisms / dnf install devscripts-checkbashisms)"
  fi
}

# ---------------------------------------------------------------- driver ---
SECTIONS="$ALL"
[ "$#" -gt 0 ] && SECTIONS="$*"

for _s in $SECTIONS; do
  case " $ALL " in
    *" $_s "*) "sec_$_s" ;;
    *)
      printf 'unknown section: %s (known: %s)\n' "$_s" "$ALL" >&2
      exit 2
      ;;
  esac
done

printf '\nRESULT: %d ok, %d warn, %d fail\n' "$_ok" "$_warn" "$_fail"
[ "$_fail" -eq 0 ] || exit 1
