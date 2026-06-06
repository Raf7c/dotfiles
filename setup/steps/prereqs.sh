#!/usr/bin/env sh
# Module: prereqs — package manager + base tools.
#
# Contract:
#   - idempotent: command -v before installing
#   - macOS: install Homebrew if missing (the installer also sets up the Command
#            Line Tools -> git), then load its env IN THIS RUN (eval shellenv).
#            Confirmation (unless --yes) since it's a system bootstrap.
#   - Linux: git + curl via the native package manager (sudo); no confirm (packages).
#   - after any install: `hash -r` (refresh command lookup)
#   - dry-run: via run(), EXCEPT the Homebrew command (`$(curl …)` substitution)
#     which is handled by hand so curl is not executed in dry-run.

if is_macos; then
  # ------------------ Homebrew ------------------
  if command -v brew >/dev/null 2>&1; then
    log_ok "Homebrew already present"
  elif confirm "Install Homebrew (macOS package manager)?"; then
    if [ "$DRY_RUN" = 1 ]; then
      log_info "[dry-run] install Homebrew (curl … install.sh | bash)"
    else
      log_info "installing Homebrew…"
      [ "$ASSUME_YES" = 1 ] && export NONINTERACTIVE=1
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
  else
    log_warn "Homebrew not installed -> packages will fail on macOS"
  fi

  # Load brew in THIS run (Apple Silicon only: /opt/homebrew).
  if [ "$DRY_RUN" != 1 ]; then
    [ -x /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"
    hash -r
  fi
else
  # ------------------ Linux: git + curl ------------------
  pkg_install git curl
  [ "$DRY_RUN" != 1 ] && hash -r
fi

# Final check (non-blocking: install may have been declined / partial).
if [ "$DRY_RUN" != 1 ]; then
  command -v git  >/dev/null 2>&1 || log_warn "git not found after prereqs"
  command -v curl >/dev/null 2>&1 || log_warn "curl not found after prereqs"
fi

log_ok "prerequisites ready"
