#!/usr/bin/env sh
# Step packages: the repo packages (Brewfile / fedora.txt) plus the recipes
# that need neither sudo nor a third-party repo (mise, starship, claude code).
# Who installs what, and what stays in your hands: docs/packages.md.

# mise is not in the Fedora repos: the official script into ~/.local/bin is the
# only route that needs no sudo. macOS gets it from brew instead.
_install_mise() {
  command -v mise >/dev/null 2>&1 && {
    log_ok "mise already present"
    return 0
  }
  [ -x "$HOME/.local/bin/mise" ] && {
    log_ok "mise already present (~/.local/bin)"
    return 0
  }
  if [ "$DRY_RUN" = 1 ]; then
    log_info "[dry-run] mise: download https://mise.run, then run it -> ~/.local/bin"
    return 0
  fi
  log_info "installing mise…"
  # Download THEN execute, never curl|sh: a truncated download must not reach
  # the shell. Pin a published checksum here to go further.
  _tmp=$(mktemp) || {
    log_warn "mise: mktemp failed"
    return 0
  }
  if curl -fsSL -o "$_tmp" -- https://mise.run; then
    sh "$_tmp" || log_warn "mise: installation failed"
  else
    log_warn "mise: download failed"
  fi
  rm -f -- "$_tmp"
}

_install_starship() {
  command -v starship >/dev/null 2>&1 && {
    log_ok "starship already present"
    return 0
  }
  if [ "$DRY_RUN" = 1 ]; then
    log_info "[dry-run] starship: official script -> ~/.local/bin"
    return 0
  fi
  log_info "installing starship…"
  mkdir -p "$HOME/.local/bin"
  _tmp=$(mktemp) || {
    log_warn "starship: mktemp failed"
    return 0
  }
  if curl -fsSL -o "$_tmp" -- https://starship.rs/install.sh; then
    sh "$_tmp" --yes --bin-dir "$HOME/.local/bin" ||
      log_warn "starship: installation failed"
  else
    log_warn "starship: download failed"
  fi
  rm -f -- "$_tmp"
}

# Native installer on BOTH OSes: the brew formula lags behind releases and
# Fedora does not package it. It self-updates in the background afterwards.
_install_claude() {
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
  _tmp=$(mktemp) || {
    log_warn "claude code: mktemp failed"
    return 0
  }
  if curl -fsSL -o "$_tmp" -- https://claude.ai/install.sh; then
    bash "$_tmp" || log_warn "claude code: installation failed"
  else
    log_warn "claude code: download failed"
  fi
  rm -f -- "$_tmp"
}

# --- logic ---

if is_macos; then
  # No brew on macOS means prereqs failed: fail loudly rather than silently
  # skipping every package.
  if [ "$DRY_RUN" != 1 ] && ! require_cmd brew; then
    log_error "brew required on macOS -> install aborted"
    return 1
  fi
  # run_soft: one formula that fails to build must not take the install with it.
  run_soft brew bundle --file "$DOTFILES_DIR/setup/packages/Brewfile"

  # safe recipe (outside brew on purpose)
  _install_claude

  [ "$DRY_RUN" = 1 ] || hash -r
  log_ok "macOS packages (brew bundle) ok"
else
  # Fedora: repo packages (dnf)
  _list="$DOTFILES_DIR/setup/packages/$OS.txt"
  if [ -r "$_list" ]; then
    _pkgs=$(awk 'NF && $1 !~ /^#/ { print $1 }' "$_list" | tr '\n' ' ')
    log_info "packages ($OS): $_pkgs"
    # shellcheck disable=SC2086
    pkg_install $_pkgs
  else
    log_warn "package list missing: $_list"
  fi

  # safe recipes (no sudo/repo)
  _install_mise
  _install_starship
  _install_claude

  [ "$DRY_RUN" = 1 ] || hash -r
  log_ok "Linux packages ($OS) ok"
fi

# Security floor. PERISHABLE: the version and what it closes are documented in
# docs/packages.md, revise both together.
if command -v mise >/dev/null 2>&1; then
  _mv=$(mise --version 2>/dev/null | awk '{print $1}')
  if [ -n "$_mv" ] && [ "$(printf '%s\n' 2026.7.14 "$_mv" | sort -V | head -n1)" != "2026.7.14" ]; then
    log_warn "mise $_mv < 2026.7.14 (known CVEs) -> upgrade it"
  fi
  unset _mv
fi
