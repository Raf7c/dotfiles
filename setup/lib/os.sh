#!/usr/bin/env sh
# lib/os.sh: OS detection. Exposes OS ∈ {macos, fedora, unknown}.

detect_os() {
  case "$(uname -s)" in
    Darwin) OS=macos ;;
    Linux)
      if [ -r /etc/os-release ]; then
        # /etc/os-release defines ID
        # shellcheck disable=SC1091
        . /etc/os-release
        # ID only, never ID_LIKE: a Rocky or a CentOS Stream would pass the
        # door and then receive fedora.txt, which does not transpose: eza is
        # missing from the EPEL branch these ship, and EPEL has to be enabled
        # first anyway. "Refuses an unknown OS" has to mean it.
        case "${ID:-}" in
          fedora) OS=fedora ;;
          *) OS=unknown ;;
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

# Fedora only: macOS goes through `brew bundle`, not this function.
pkg_install() {
  [ "$#" -gt 0 ] || return 0
  case "${OS:-}" in
    # run_soft: an unreachable mirror must be reported, not abort the run.
    fedora) run_soft sudo dnf install -y "$@" ;;
    # Unreachable today: run exits on OS=unknown and both callers sit in the
    # `else` of an is_macos test. Kept as the failure mode of a documented
    # public helper (docs/installer.md), for a future step calling it wrongly.
    *)
      log_warn "pkg_install: unsupported OS ($OS)"
      return 1
      ;;
  esac
}
