#!/usr/bin/env sh
# Step packages: the repo packages (Brewfile / fedora.txt) plus the recipes
# that need neither sudo nor a third-party repo (mise, starship, claude code).
# Who installs what, and what stays in your hands: docs/packages.md.

# Install a tool from its official script. Download THEN execute, never
# curl|sh: a truncated download must not reach the shell. Pin a published
# checksum here to go further.
# Both presence checks matter: these installers never touch PATH, so a shell
# started before ~/.local/bin existed would reinstall on every run.
#   $1 binary · $2 label for the logs · $3 URL · $4 interpreter
#   $5 dry-run wording · $6… arguments for the downloaded script
_install_script() {
  _is_bin=$1 _is_label=$2 _is_url=$3 _is_interp=$4 _is_msg=$5
  shift 5
  command -v "$_is_bin" >/dev/null 2>&1 && {
    log_ok "$_is_label already present"
    return 0
  }
  [ -x "$HOME/.local/bin/$_is_bin" ] && {
    log_ok "$_is_label already present (~/.local/bin)"
    return 0
  }
  if [ "$DRY_RUN" = 1 ]; then
    log_info "[dry-run] $_is_msg"
    return 0
  fi
  log_info "installing $_is_label…"
  mkdir -p -- "$HOME/.local/bin"
  # Inside log.sh's private mktemp -d, like gitsign and extras_linux: one trap
  # cleans up every scratch file, interruption included. No mktemp here means
  # no mktemp failure to grade.
  _tmp="${_log_dir:?log.sh not sourced}/install-$_is_bin"
  if curl -fsSL -o "$_tmp" -- "$_is_url"; then
    "$_is_interp" "$_tmp" "$@" || log_error "$_is_label: installation failed"
  else
    log_error "$_is_label: download failed"
  fi
  rm -f -- "$_tmp"
}

# The three recipes below are data, not logic: only the arguments differ.

# mise is not in the Fedora repos: the official script into ~/.local/bin is the
# only route that needs no sudo. macOS gets it from brew instead.
_install_mise() {
  _install_script mise mise https://mise.run sh \
    "mise: download https://mise.run, then run it -> ~/.local/bin"
}

_install_starship() {
  _install_script starship starship https://starship.rs/install.sh sh \
    "starship: official script -> ~/.local/bin" \
    --yes --bin-dir "$HOME/.local/bin"
}

# Native installer on BOTH OSes: the brew formula lags behind releases and
# Fedora does not package it. It self-updates in the background afterwards.
_install_claude() {
  _install_script claude "claude code" https://claude.ai/install.sh bash \
    "claude code: download https://claude.ai/install.sh, then run it"
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

  hash -r
  log_ok "macOS packages (brew bundle) ok"
else
  # Fedora: repo packages (dnf)
  # fedora.txt, not "$OS.txt": run exits on an unknown OS and is_macos took the
  # other branch, so this line has exactly one possible value. os.sh refuses
  # every other Linux on purpose; a second list would be a second decision.
  _list="$DOTFILES_DIR/setup/packages/fedora.txt"
  if [ -r "$_list" ]; then
    _pkgs=$(awk 'NF && $1 !~ /^#/ { print $1 }' "$_list" | tr '\n' ' ')
    log_info "packages (fedora): $_pkgs"
    # shellcheck disable=SC2086
    pkg_install $_pkgs
  else
    log_warn "package list missing: $_list"
  fi

  # safe recipes (no sudo/repo)
  _install_mise
  _install_starship
  _install_claude

  hash -r
  log_ok "Fedora packages ok"
fi

# Security floor. PERISHABLE: the version and what it closes are documented in
# docs/packages.md, revise both together.
if command -v mise >/dev/null 2>&1; then
  _mv=$(mise --version 2>/dev/null | awk '{print $1}')
  if [ -n "$_mv" ] && [ "$(printf '%s\n' 2026.6.5 "$_mv" | sort -V | head -n1)" != "2026.6.5" ]; then
    log_warn "mise $_mv < 2026.6.5 (published advisories) -> upgrade it"
  fi
  unset _mv
fi

# Steps are sourced in the same shell: leave nothing behind for the next one.
unset _tmp _list _pkgs _is_bin _is_label _is_url _is_interp _is_msg
unset -f _install_script _install_mise _install_starship _install_claude
