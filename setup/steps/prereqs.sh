#!/usr/bin/env sh
# Step prereqs: package manager + base tools. macOS installs Homebrew, which
# also brings the Command Line Tools and therefore git; Fedora installs
# git + curl. Asks before the Homebrew bootstrap: it is a system change.

if is_macos; then
  # ------------------ Homebrew ------------------
  if command -v brew >/dev/null 2>&1; then
    log_ok "Homebrew already present"
  elif confirm "Install Homebrew (macOS package manager)?"; then
    if [ "$DRY_RUN" = 1 ]; then
      log_info "[dry-run] install Homebrew (curl … install.sh | bash)"
    else
      log_info "installing Homebrew…"
      # Exported for the WHOLE run, not just this installer: steps are sourced
      # in the same shell and nothing unsets it, so the `brew bundle` of the
      # packages step sees it too. That is intended — `-y` means "ask me
      # nothing" for the entire command, not for one download.
      [ "$ASSUME_YES" = 1 ] && export NONINTERACTIVE=1
      # Download THEN execute: a failed curl must not expand to an empty
      # string silently executed by `bash -c`.
      _hb=$(curl -fsSL -- https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh) ||
        {
          log_error "Homebrew: download failed (network?)"
          unset _hb
          return 1
        }
      /bin/bash -c "$_hb" ||
        {
          log_error "Homebrew: installer failed"
          unset _hb
          return 1
        }
      unset _hb
    fi
  else
    log_warn "Homebrew not installed -> packages will fail on macOS"
  fi

  # Load brew in THIS run, so the packages step finds it. Apple Silicon path
  # only: gitsign.sh is the one that has to cover intel too.
  if [ "$DRY_RUN" != 1 ]; then
    [ -x /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
  # Outside the guard, like every other hash -r here: it clears the shell's
  # command cache, never $HOME nor the system, so dry-run has nothing to hide.
  hash -r
else
  # ------------------ Linux: git + curl ------------------
  pkg_install git curl
  hash -r
fi

# Non-blocking: the install may have been declined.
_pr_ready=1
if [ "$DRY_RUN" != 1 ]; then
  command -v git >/dev/null 2>&1 || {
    log_warn "git not found after prereqs"
    _pr_ready=0
  }
  command -v curl >/dev/null 2>&1 || {
    log_warn "curl not found after prereqs"
    _pr_ready=0
  }
fi

# The ✓ used to print right under those two warnings, contradicting them.
# log_info rather than a third log_warn: the warnings above are already counted.
if [ "$_pr_ready" = 1 ]; then
  log_done "prerequisites ready"
else
  log_info "prerequisites incomplete (see the warnings above)"
fi
unset _pr_ready
