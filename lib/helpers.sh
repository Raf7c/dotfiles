# lib/helpers.sh — POSIX sh; sourced by dot and leaf scripts.

info()  { printf '==> %s\n' "$1"; }
warn()  { printf 'warning: %s\n' "$1" >&2; }
fail()  { printf 'error: %s\n' "$1" >&2; exit 1; }

detect_os() {
  case "$(uname -s)" in
    Darwin) printf '%s' macos ;;
    Linux)  printf '%s' linux ;;
    *)      printf '%s' unknown ;;
  esac
}

# Run a script; missing file is a no-op (safe if a path is absent).
run_script() {
  f="$1"
  if [ ! -f "$f" ]; then
    return 0
  fi
  if [ -x "$f" ]; then
    "$f"
  else
    sh "$f"
  fi
}
