#!/usr/bin/env sh
# Step extras: the four tools Fedora does not package, checked one by one
# against packages.fedoraproject.org (docs/packages.md). Fedora only, brew
# carries all four on macOS. Not replayed by `update`, see docs/installer.md.

# PERISHABLE: bump deliberately. The download is checked against the checksums
# file published with THAT release, so version and check move together.
_ex_sops_version="3.13.3"

# packages and runtimes just wrote binaries: drop the shell's command cache.
hash -r 2>/dev/null || true

# Guard on Fedora, not on "not macOS": on any other Linux the COPR commands
# below would simply not exist.
if ! is_fedora; then
  if is_macos; then
    log_ok "extras: brew already covers these on macOS"
  else
    log_info "extras: Fedora only, nothing to do on $OS"
  fi
  return 0
fi

# --- lazygit -----------------------------------------------------------------
# dejan/lazygit is the COPR lazygit's own README points at. It asks first
# because a COPR is signed by its maintainer, not by Fedora.
_ex_install_lazygit() {
  if command -v lazygit >/dev/null 2>&1; then
    log_ok "lazygit already present"
    return 0
  fi
  if ! confirm "extras: enable the third-party COPR dejan/lazygit (sudo)?"; then
    log_info "lazygit skipped, the recipe stays in docs/packages.md"
    return 0
  fi
  # Since Fedora 41 `dnf` IS dnf5, and `copr` ships in dnf5-plugins. NOT
  # dnf-plugins-core: it still exists but only gives `dnf-3 copr`, so writing
  # that name here would be a silent no-op.
  run_soft sudo dnf install -y dnf5-plugins
  run_soft sudo dnf copr enable -y dejan/lazygit
  run_soft sudo dnf install -y lazygit
}

# --- sops --------------------------------------------------------------------
# The release ships a checksums file, so nothing lands on the PATH before it
# matches. ~/.local/bin, no sudo.
_ex_install_sops() {
  # Look at ~/.local/bin too, not just the PATH: this step installs there and
  # the installer never touches PATH, so a shell started before that directory
  # existed would reinstall on every run. Same fallback as mise and claude in
  # the packages step.
  # A pin only means something if it is enforced: a differing version is
  # replaced, otherwise bumping it above would silently do nothing.
  # SOPS_DISABLE_VERSION_CHECK keeps this off the network without relying on a
  # flag an older binary might reject.
  _ex_bin=$(command -v sops 2>/dev/null || printf '%s' "$HOME/.local/bin/sops")
  if [ -x "$_ex_bin" ]; then
    _ex_got=$(SOPS_DISABLE_VERSION_CHECK=1 "$_ex_bin" --version 2>/dev/null || printf '')
    _ex_got=$(printf '%s\n' "$_ex_got" | awk 'NR == 1 { print $2 }')
    if [ "$_ex_got" = "$_ex_sops_version" ]; then
      log_ok "sops ${_ex_sops_version} already present"
      return 0
    fi
    log_info "sops ${_ex_got:-unknown} installed, the pin says ${_ex_sops_version}"
  fi
  case "$(uname -m)" in
    x86_64) _ex_arch=amd64 ;;
    aarch64 | arm64) _ex_arch=arm64 ;;
    *)
      log_warn "sops: no release build for $(uname -m), skipped"
      return 0
      ;;
  esac
  _ex_asset="sops-v${_ex_sops_version}.linux.${_ex_arch}"
  _ex_url="https://github.com/getsops/sops/releases/download/v${_ex_sops_version}"
  if [ "$DRY_RUN" = 1 ]; then
    log_info "[dry-run] sops ${_ex_sops_version}: download ${_ex_asset} + checksums, verify, -> ~/.local/bin"
    return 0
  fi
  _ex_tmp="${_log_dir:?log.sh not sourced}"
  log_info "installing sops ${_ex_sops_version}…"
  if ! curl -fsSL -o "$_ex_tmp/$_ex_asset" -- "$_ex_url/$_ex_asset"; then
    log_warn "sops: download failed"
    return 0
  fi
  if ! curl -fsSL -o "$_ex_tmp/sops.checksums" -- "$_ex_url/sops-v${_ex_sops_version}.checksums.txt"; then
    log_warn "sops: checksums download failed, nothing installed"
    return 0
  fi
  # Integrity, not authenticity: same release, so a truncated or altered
  # download is caught, a compromised release is not. See docs/installer.md.
  _ex_want=$(awk -v f="$_ex_asset" '$2 == f { print $1 }' "$_ex_tmp/sops.checksums")
  _ex_got=$(sha256sum "$_ex_tmp/$_ex_asset" | cut -d' ' -f1)
  if [ -z "$_ex_want" ]; then
    log_error "sops: $_ex_asset absent from the checksums file, nothing installed"
    return 0
  fi
  if [ "$_ex_want" != "$_ex_got" ]; then
    log_error "sops: checksum mismatch, nothing installed"
    return 0
  fi
  mkdir -p -- "$HOME/.local/bin"
  install -m 0755 -- "$_ex_tmp/$_ex_asset" "$HOME/.local/bin/sops"
  log_ok "sops ${_ex_sops_version} installed (checksum verified)"
}

# --- age-plugin-yubikey ------------------------------------------------------
# rust is already here: runtimes ran just before. --root puts the binary in
# ~/.local/bin, which env.sh exports, instead of the ~/.cargo/bin that nothing
# adds. Build headers: docs/packages.md.
_ex_install_age_plugin() {
  if command -v age-plugin-yubikey >/dev/null 2>&1; then
    log_ok "age-plugin-yubikey already present"
    return 0
  fi
  # On a fresh machine the shell started BEFORE mise existed, so env.sh could
  # not prepend a shims directory that was not there yet, and the installer
  # never touches PATH. Fall back to the known shim path, exactly as
  # runtimes.sh does for mise itself.
  _ex_cargo=$(command -v cargo 2>/dev/null ||
    printf '%s' "${XDG_DATA_HOME:-$HOME/.local/share}/mise/shims/cargo")
  if [ ! -x "$_ex_cargo" ]; then
    if [ "$DRY_RUN" = 1 ]; then
      log_info "[dry-run] age-plugin-yubikey: cargo install --root ~/.local (rust from runtimes)"
    else
      log_warn "age-plugin-yubikey: no cargo, not even a mise shim, skipped"
    fi
    return 0
  fi
  run_soft "$_ex_cargo" install --root "$HOME/.local" age-plugin-yubikey
}

# --- JetBrainsMono Nerd Font -------------------------------------------------
# `latest` on purpose: a font carries no security surface, and the checksum
# file comes from the same release, so the pair stays consistent.
_ex_install_font() {
  _ex_fontdir="${XDG_DATA_HOME:-$HOME/.local/share}/fonts/JetBrainsMonoNerd"
  if [ -d "$_ex_fontdir" ]; then
    log_ok "JetBrainsMono Nerd Font already present"
    return 0
  fi
  if [ "$DRY_RUN" = 1 ]; then
    log_info "[dry-run] Nerd Font: download JetBrainsMono.tar.xz + SHA-256.txt, verify, unpack -> ${_ex_fontdir#"$HOME"/}"
    return 0
  fi
  _ex_tmp="${_log_dir:?log.sh not sourced}"
  _ex_url="https://github.com/ryanoasis/nerd-fonts/releases/latest/download"
  log_info "installing the JetBrainsMono Nerd Font…"
  if ! curl -fsSL -o "$_ex_tmp/JetBrainsMono.tar.xz" -- "$_ex_url/JetBrainsMono.tar.xz"; then
    log_warn "Nerd Font: download failed"
    return 0
  fi
  if ! curl -fsSL -o "$_ex_tmp/SHA-256.txt" -- "$_ex_url/SHA-256.txt"; then
    log_warn "Nerd Font: checksums download failed, nothing installed"
    return 0
  fi
  _ex_want=$(awk '$2 ~ /JetBrainsMono\.tar\.xz$/ { print $1 }' "$_ex_tmp/SHA-256.txt")
  _ex_got=$(sha256sum "$_ex_tmp/JetBrainsMono.tar.xz" | cut -d' ' -f1)
  if [ -z "$_ex_want" ]; then
    log_error "Nerd Font: no line for JetBrainsMono.tar.xz in SHA-256.txt, nothing installed"
    return 0
  fi
  if [ "$_ex_want" != "$_ex_got" ]; then
    log_error "Nerd Font: checksum mismatch, nothing installed"
    return 0
  fi
  mkdir -p -- "$_ex_fontdir"
  if tar -xJf "$_ex_tmp/JetBrainsMono.tar.xz" -C "$_ex_fontdir"; then
    run_soft fc-cache -f "${XDG_DATA_HOME:-$HOME/.local/share}/fonts"
    log_ok "JetBrainsMono Nerd Font installed (checksum verified)"
  else
    log_error "Nerd Font: unpacking failed"
    rmdir -- "$_ex_fontdir" 2>/dev/null || true
  fi
}

# --- run them ----------------------------------------------------------------
_ex_install_lazygit
_ex_install_sops
_ex_install_age_plugin
_ex_install_font

command -v flatpak >/dev/null 2>&1 ||
  log_info "flatpak missing -> the GUI recipes in docs/packages.md need it"

[ "$DRY_RUN" = 1 ] || hash -r
unset _ex_sops_version _ex_arch _ex_asset _ex_url _ex_tmp _ex_want _ex_got _ex_fontdir _ex_cargo _ex_bin
