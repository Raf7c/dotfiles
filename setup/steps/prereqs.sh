#!/usr/bin/env sh
# Step prereqs: package manager + base tools. Homebrew also brings the Command
# Line Tools, and therefore git and curl. Asks before the bootstrap: it is a
# system change.

# --- Homebrew ---
if command -v brew >/dev/null 2>&1; then
  log_ok "Homebrew already present"
elif confirm "Install Homebrew (macOS package manager)?"; then
  if [ "$DRY_RUN" = 1 ]; then
    # NOT "curl … | bash": the code below downloads to a variable first, and
    # a preview showing the pattern the code avoids would be a lie.
    log_info "[dry-run] Homebrew: download install.sh, then run it"
  else
    log_info "installing Homebrew…"
    # Exported for the WHOLE run: steps are sourced in the same shell, so
    # `brew bundle` sees it too. Intended -- `-y` means "ask me nothing".
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

# Load brew in THIS run, so the packages step finds it. Apple Silicon only:
# gitsign.sh is the one that has to cover intel too.
if [ "$DRY_RUN" != 1 ]; then
  [ -x /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"
fi
# Outside the guard: `hash -r` clears the shell's command cache, never $HOME
# nor the system, so dry-run has nothing to hide.
hash -r

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

# log_info rather than a third log_warn: the warnings above are already
# counted. This branch covers the WARNING case, which log_done_clean leaves
# alone on purpose; the helper covers the error case underneath it.
if [ "$_pr_ready" = 1 ]; then
  log_done_clean "prerequisites ready" \
    "prerequisites: something failed (see the ✗ above)"
else
  log_info "prerequisites incomplete (see the warnings above)"
fi
unset _pr_ready
