#!/usr/bin/env sh
# Module: packages — install CLI packages/apps.
#
# Scope ("repo + safe recipes"):
#   1. repo packages     (packages/fedora.txt -> pkg_install)   [Fedora]
#   2. safe recipes WITHOUT sudo/repo: mise + starship (scripts) -> ~/.local/bin
#      + claude code (official script, BOTH OSes: no brew on purpose —
#        releases move faster than the formula; not packaged for Fedora)
#   3. out of scope (lazygit) -> warning, without blocking
#
# Contract:
#   - idempotent: brew bundle / dnf; `command -v` before the recipes
#   - OS: macOS -> brew bundle Brewfile; Fedora -> pkg_install + recipes
#   - sudo: yes on Fedora (dnf); NOT for mise/starship (~/.local/bin)
#   - dry-run: via run(), + handled by hand for curl|sh
#   - end: hash -r (so runtimes finds mise)

# _install_mise: official script -> ~/.local/bin (mise: brew on macOS, else here).
# (mise is NOT in the Fedora repos: the official script is the way, no sudo.)
_install_mise() {
  command -v mise >/dev/null 2>&1 && { log_ok "mise already present"; return 0; }
  [ -x "$HOME/.local/bin/mise" ] && { log_ok "mise already present (~/.local/bin)"; return 0; }
  if [ "$DRY_RUN" = 1 ]; then
    log_info "[dry-run] mise: curl https://mise.run | sh -> ~/.local/bin"
    return 0
  fi
  log_info "installing mise…"
  # Download THEN execute (no curl|sh): a failed/truncated download must
  # never reach the shell. Pin a published checksum here to go further.
  _tmp=$(mktemp) || { log_warn "mise: mktemp failed"; return 0; }
  if curl -fsSL -o "$_tmp" -- https://mise.run; then
    sh "$_tmp" || log_warn "mise: installation failed"
  else
    log_warn "mise: download failed"
  fi
  rm -f -- "$_tmp"
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
  _tmp=$(mktemp) || { log_warn "starship: mktemp failed"; return 0; }
  if curl -fsSL -o "$_tmp" -- https://starship.rs/install.sh; then
    sh "$_tmp" --yes --bin-dir "$HOME/.local/bin" \
      || log_warn "starship: installation failed"
  else
    log_warn "starship: download failed"
  fi
  rm -f -- "$_tmp"
}

# _install_claude: official native installer -> ~/.local/bin (no sudo).
# Deliberately NOT via brew (formula lags behind releases) nor dnf (not
# packaged). The native install self-updates in the background.
_install_claude() {
  command -v claude >/dev/null 2>&1 && { log_ok "claude code already present"; return 0; }
  [ -x "$HOME/.local/bin/claude" ] && { log_ok "claude code already present (~/.local/bin)"; return 0; }
  if [ "$DRY_RUN" = 1 ]; then
    log_info "[dry-run] claude code: curl https://claude.ai/install.sh | bash"
    return 0
  fi
  log_info "installing claude code…"
  _tmp=$(mktemp) || { log_warn "claude code: mktemp failed"; return 0; }
  if curl -fsSL -o "$_tmp" -- https://claude.ai/install.sh; then
    bash "$_tmp" || log_warn "claude code: installation failed"
  else
    log_warn "claude code: download failed"
  fi
  rm -f -- "$_tmp"
}

# --- logic ---

if is_macos; then
  # brew missing on macOS = broken install (prereqs failed?): fail loudly,
  # don't silently skip every package.
  if [ "$DRY_RUN" != 1 ] && ! require_cmd brew; then
    log_error "brew required on macOS -> install aborted"
    exit 1
  fi
  run brew bundle --file "$DOTFILES_DIR/setup/packages/Brewfile"

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

  # out of scope: lazygit (Fedora -> COPR atim/lazygit)
  command -v lazygit >/dev/null 2>&1 || log_warn "lazygit missing -> COPR atim/lazygit (see ${_list##*/})"

  [ "$DRY_RUN" = 1 ] || hash -r
  log_ok "Linux packages ($OS) ok"
fi
