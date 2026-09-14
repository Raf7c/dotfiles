#!/usr/bin/env sh
# Install norminette (42 school) + c_formatter_42, from pipx when it is there
# and from pip otherwise. Everything lands in the user's own tree: no root, and
# nothing written outside the home directory.
set -eu

# Python 3.10+: norminette sets the floor (c_formatter_42 asks 3.7).
command -v python3 >/dev/null 2>&1 || {
  printf 'Error: python3 required (3.10+ for norminette).\n' >&2
  exit 1
}
# Checked, not merely announced: an install against an older python would fail
# far from here.
python3 -c 'import sys; sys.exit(0 if sys.version_info >= (3, 10) else 1)' || {
  printf 'Error: python3 %s is too old, norminette needs 3.10+.\n' \
    "$(python3 -c 'import sys; print(".".join(map(str, sys.version_info[:3])))')" >&2
  exit 1
}

# mktemp, not a fixed name: on a shared machine /tmp/<fixed> is both a
# collision and a symlink target someone else can plant.
_err=$(mktemp) || {
  printf 'Error: mktemp failed.\n' >&2
  exit 1
}
trap 'rm -f -- "$_err"' EXIT INT TERM

# --- Backend ---
# pipx first: it isolates each tool in its own venv. pip is the fallback for a
# machine that has python3 but no pipx.
if command -v pipx >/dev/null 2>&1; then
  _backend=pipx
  _bindir=$(pipx environment --value PIPX_BIN_DIR 2>/dev/null ||
    printf '%s/.local/bin' "$HOME")
  # `pipx upgrade --install` only exists from pipx 1.5. A distribution pipx is
  # often older, so the capability is probed, not assumed; `install --force`
  # is the equivalent everywhere, at the cost of rebuilding the venv each run.
  if pipx upgrade --help 2>/dev/null | grep -q -- --install; then
    _pipx=upgrade
  else
    _pipx=force
  fi
else
  _backend=pip
  python3 -m pip --version >/dev/null 2>&1 || {
    printf 'Error: neither pipx nor pip is available for %s.\n' \
      "$(command -v python3)" >&2
    exit 1
  }
  # Asked, not assumed: a macOS framework python answers
  # ~/Library/Python/3.x/bin here, not ~/.local/bin.
  _bindir=$(python3 -c 'import sysconfig
print(sysconfig.get_path("scripts", sysconfig.get_preferred_scheme("user")))')
fi

printf 'Installing norminette and c_formatter_42\n'
printf '  backend : %s\n' "$_backend"
printf '  target  : %s\n' "$_bindir"

# One package, whichever backend. pip gets --upgrade so a second run behaves
# like `pipx upgrade --install`: install or move forward, never fail on an
# already-satisfied requirement.
_install() {
  if [ "$_backend" = pipx ]; then
    if [ "$_pipx" = upgrade ]; then
      pipx upgrade --install "$1"
    else
      pipx install --force "$1"
    fi
    return 0
  fi
  if python3 -m pip install --user --upgrade --quiet -- "$1" 2>"$_err"; then
    return 0
  fi
  # PEP 668: a distribution python refuses --user outright. Combined with
  # --user the override still writes under the home directory only -- the
  # system stays untouched, and root is never needed.
  if ! grep -q externally-managed-environment "$_err"; then
    cat -- "$_err" >&2
    printf 'Error: %s: installation failed.\n' "$1" >&2
    return 1
  fi
  if ! python3 -m pip install --help 2>/dev/null | grep -q -- --break-system-packages; then
    printf 'Error: %s: this python is externally managed (PEP 668) and its pip\n' "$1" >&2
    printf '       predates --break-system-packages. Install pipx instead.\n' >&2
    return 1
  fi
  printf '  note    : externally managed python, retrying with --break-system-packages\n'
  if ! python3 -m pip install --user --break-system-packages --upgrade --quiet -- "$1"; then
    printf 'Error: %s: installation failed.\n' "$1" >&2
    return 1
  fi
}

# Norminette: https://github.com/42school/norminette
_install norminette
# c_formatter_42: https://github.com/dawnbeen/c_formatter_42
_install c-formatter-42

# --- Verification ---
# Looks at the file, not at `command -v`: a binary can be installed and still be
# invisible to this shell, which is a different problem with a different fix.
_rc=0
for _bin in norminette c_formatter_42; do
  if [ -x "$_bindir/$_bin" ]; then
    printf 'ok      : %s\n' "$_bindir/$_bin"
  else
    printf 'MISSING : %s -- expected after a successful install\n' \
      "$_bindir/$_bin" >&2
    _rc=1
  fi
done

# A warning, not an error: the install did happen, it is the shell that cannot
# see it yet.
case ":${PATH:-}:" in
  *":$_bindir:"*) ;;
  *)
    printf 'WARNING : %s is not on PATH, so neither command resolves yet.\n' \
      "$_bindir" >&2
    ;;
esac

[ "$_rc" -eq 0 ] && printf 'Usage: norminette [file.c], c_formatter_42 < file.c\n'
exit "$_rc"
