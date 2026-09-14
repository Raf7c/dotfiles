#!/usr/bin/env sh
# Step packages: the repo packages (Brewfile) plus the one recipe that needs
# neither sudo nor a third-party repo (claude code).
# Who installs what, and what stays in your hands: docs/outils.md.

# Not brew: the formula lags behind its releases. The `cask "claude"` in the
# Brewfile is the DESKTOP app -- no binary artifact, nothing on the PATH, the
# two never meet. Download THEN execute, never curl|sh.
_install_claude() {
  # Both checks matter: the installer never touches PATH, so a shell started
  # before ~/.local/bin existed would reinstall on every run.
  command -v claude >/dev/null 2>&1 && {
    log_ok "claude code already present"
    return 0
  }
  [ -x "$HOME/.local/bin/claude" ] && {
    log_ok "claude code already present (~/.local/bin)"
    return 0
  }
  if [ "$DRY_RUN" = 1 ]; then
    log_info "[dry-run] claude code: download https://claude.ai/install.sh, then run it"
    return 0
  fi
  log_info "installing claude code…"
  mkdir -p -- "$HOME/.local/bin"
  # Inside log.sh's private mktemp -d, like gitsign: one trap cleans up every
  # scratch file, interruption included.
  _tmp="${_log_dir:?log.sh not sourced}/install-claude"
  if curl -fsSL -o "$_tmp" -- https://claude.ai/install.sh; then
    bash "$_tmp" || log_error "claude code: installation failed"
  else
    log_error "claude code: download failed"
  fi
  rm -f -- "$_tmp"
}

# --- logic ---

# No brew means prereqs failed: fail loudly rather than silently skipping
# every package.
if [ "$DRY_RUN" != 1 ] && ! require_cmd brew; then
  log_error "brew required -> install aborted"
  return 1
fi
# run_soft: one formula that fails to build must not take the install with it.
# --file explicitly, never brew's own default: the step must read THIS repo's
# list whatever directory `./run` was invoked from.
run_soft brew bundle --file "$DOTFILES_DIR/Brewfile"

# safe recipe (outside brew on purpose)
_install_claude

hash -r
log_done_clean "packages (brew bundle) ok" \
  "packages: brew bundle or claude code failed (see the ✗ above)"

# Steps are sourced in the same shell: leave nothing behind for the next one.
unset _tmp
unset -f _install_claude
