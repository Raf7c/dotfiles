#!/usr/bin/env sh
# lib/os.sh: OS detection and specifics. Sourced by run.
# Exposes: OS ∈ {macos, fedora, unknown}.

detect_os() {
  case "$(uname -s)" in
    Darwin) OS=macos ;;
    Linux)
      if [ -r /etc/os-release ]; then
        # /etc/os-release defines ID and ID_LIKE
        # shellcheck disable=SC1091
        . /etc/os-release
        case "${ID:-}" in
          fedora) OS=fedora ;;
          *)
            case " ${ID_LIKE:-} " in
              *fedora* | *rhel*) OS=fedora ;;
              *) OS=unknown ;;
            esac
            ;;
        esac
      else
        OS=unknown
      fi
      ;;
    *) OS=unknown ;;
  esac
  export OS
}

is_macos() { [ "${OS:-}" = macos ]; }
is_fedora() { [ "${OS:-}" = fedora ]; }

# pkg_install PKG... : install packages via dnf (Fedora).
# (macOS goes through `brew bundle`, not this function.)
pkg_install() {
  [ "$#" -gt 0 ] || return 0
  case "${OS:-}" in
    # run_soft: an unreachable mirror or one renamed package must be
    # reported, not abort the run (`set -e`) before the rest of the steps.
    fedora) run_soft sudo dnf install -y "$@" ;;
    *)
      log_warn "pkg_install: unsupported OS ($OS)"
      return 1
      ;;
  esac
}
