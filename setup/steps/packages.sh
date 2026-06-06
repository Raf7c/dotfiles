#!/usr/bin/env sh
# Module: packages — install CLI packages/apps.
#
# Scope ("repo + safe recipes"):
#   1. repo packages     (packages/fedora.txt -> pkg_install)   [Fedora]
#   2. safe recipes WITHOUT sudo/repo: mise + starship (scripts) -> ~/.local/bin
#   3. out of scope (lazygit) -> warning, without blocking
#
# Contract:
#   - idempotent: brew bundle / dnf; `command -v` before the recipes
#   - OS: macOS -> brew bundle Brewfile; Fedora -> pkg_install + recipes
#   - sudo: yes on Fedora (dnf); NOT for mise/starship (~/.local/bin)
#   - dry-run: via run(), + handled by hand for curl|sh
#   - end: hash -r (so runtimes finds mise)

# _install_mise: official script -> ~/.local/bin (mise: brew on macOS, else here).
# (mise is also available in the dnf repo; we keep the script, no sudo.)
_install_mise() {
  command -v mise >/dev/null 2>&1 && { log_ok "mise already present"; return 0; }
  [ -x "$HOME/.local/bin/mise" ] && { log_ok "mise already present (~/.local/bin)"; return 0; }
  if [ "$DRY_RUN" = 1 ]; then
    log_info "[dry-run] mise: curl https://mise.run | sh -> ~/.local/bin"
    return 0
  fi
  log_info "installing mise…"
  curl -fsSL https://mise.run | sh || log_warn "mise: installation failed"
}

# _install_starship: official script -> ~/.local/bin (no sudo).
_install_starship() {
  command -v starship >/dev/null 2>&1 && { log_ok "starship already present"; return 0; }
  if [ "$DRY_RUN" = 1 ]; then
    log_info "[dry-run] starship: official script -> ~/.local/bin"
    return 0
  fi
  log_info "installing starship…"
  mkdir -p "$HOME/.local/bin"
  curl -fsSL https://starship.rs/install.sh \
    | sh -s -- --yes --bin-dir "$HOME/.local/bin" \
    || log_warn "starship: installation failed"
}

# --- logic ---

if is_macos; then
  [ "$DRY_RUN" = 1 ] || require_cmd brew || return 0
  run brew bundle --file "$DOTFILES_DIR/setup/packages/Brewfile"
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

  # out of scope: lazygit (Fedora -> COPR atim/lazygit)
  command -v lazygit >/dev/null 2>&1 || log_warn "lazygit missing -> COPR atim/lazygit (see ${_list##*/})"

  [ "$DRY_RUN" = 1 ] || hash -r
  log_ok "Linux packages ($OS) ok"
fi
