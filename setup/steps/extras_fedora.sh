#!/usr/bin/env sh
# Step extras_fedora: the four tools Fedora does not package, checked one by one
# against packages.fedoraproject.org (docs/packages.md). Fedora only, brew
# carries all four on macOS. Not replayed by `update`, see docs/installer.md.

# packages and runtimes just wrote binaries: drop the shell's command cache.
hash -r

# Guard on Fedora, not on "not macOS": on any other Linux the COPR commands
# below would simply not exist.
if ! is_fedora; then
  if is_macos; then
    log_ok "extras_fedora: brew already covers these on macOS"
  else
    log_info "extras_fedora: Fedora only, nothing to do on $OS"
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
  if ! confirm "extras_fedora: enable the third-party COPR dejan/lazygit (sudo)?"; then
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

# --- shared: download an asset and check it against the release checksums -----
# Integrity, not authenticity: the checksums file comes from the SAME release,
# so a truncated or altered transfer is caught, a compromised release is not.
# See docs/installer.md. Leaves the verified asset in $_ex_tmp on success.
#   $1 base URL · $2 asset · $3 checksums file · $4 label for the logs
_ex_fetch_verified() {
  _fv_asset=$2 _fv_sums=$3 _fv_label=$4
  if ! curl -fsSL -o "$_ex_tmp/$_fv_asset" -- "$1/$_fv_asset"; then
    log_warn "$_fv_label: download failed"
    return 1
  fi
  if ! curl -fsSL -o "$_ex_tmp/$_fv_sums" -- "$1/$_fv_sums"; then
    log_warn "$_fv_label: checksums download failed, nothing installed"
    return 1
  fi
  # Accept the bare name OR any path ending in /<name>: a release that starts
  # prefixing its paths must not silently stop matching. String comparison, not
  # a regex, so a dot in the asset name cannot act as a wildcard.
  _ex_want=$(awk -v f="$_fv_asset" \
    '$2 == f || substr($2, length($2) - length(f)) == "/" f { print $1 }' \
    "$_ex_tmp/$_fv_sums")
  _ex_got=$(sha256sum "$_ex_tmp/$_fv_asset" | cut -d' ' -f1)
  if [ -z "$_ex_want" ]; then
    log_error "$_fv_label: $_fv_asset absent from $_fv_sums, nothing installed"
    return 1
  fi
  if [ "$_ex_want" != "$_ex_got" ]; then
    log_error "$_fv_label: checksum mismatch, nothing installed"
    return 1
  fi
}

# --- sops --------------------------------------------------------------------
# The release ships a checksums file, so nothing lands on the PATH before it
# matches. ~/.local/bin, no sudo.
# `latest`, like the Nerd Font and for the same reason: the checksums file is
# published WITH the release, so integrity holds without a pin. A pin buys
# reproducibility only, and it costs a repo edit every time sops moves -- a
# version written in git that nobody bumps stops describing anything.
_ex_install_sops() {
  # Look at ~/.local/bin too, not just the PATH: this step installs there and
  # the installer never touches PATH, so a shell started before that directory
  # existed would reinstall on every run. Same fallback as mise and claude in
  # the packages step.
  # SOPS_DISABLE_VERSION_CHECK keeps this off the network without relying on a
  # flag an older binary might reject: sops phones home on --version otherwise,
  # and this reading has to be local and instant.
  _ex_bin=$(command -v sops 2>/dev/null || printf '%s' "$HOME/.local/bin/sops")
  _ex_got=''
  if [ -x "$_ex_bin" ]; then
    _ex_got=$(SOPS_DISABLE_VERSION_CHECK=1 "$_ex_bin" --version 2>/dev/null || printf '')
    _ex_got=$(printf '%s\n' "$_ex_got" | awk 'NR == 1 { print $2 }')
  fi
  # Read the installed version BEFORE this, resolve the remote one AFTER: the
  # preview stays offline and still says what it would compare.
  if [ "$DRY_RUN" = 1 ]; then
    log_info "[dry-run] sops: resolve the latest release, compare with ${_ex_got:-none installed}, download + verify if they differ"
    return 0
  fi
  # The asset name carries the version, so releases/latest/download cannot be
  # used blindly the way the font does: resolve the tag first. A plain HTTP
  # redirect, no API and no token, therefore no rate limit to depend on.
  _ex_sops_version=$(curl -fsSLI -o /dev/null -w '%{url_effective}' -- \
    https://github.com/getsops/sops/releases/latest 2>/dev/null |
    sed -n 's#.*/tag/v##p')
  # Anything but digits and dots means the redirect changed shape or the
  # network is down. Refuse rather than build a URL out of garbage.
  case "${_ex_sops_version:-}" in
    '' | *[!0-9.]*)
      log_warn "sops: cannot resolve the latest release (network?), nothing installed"
      return 0
      ;;
  esac
  if [ -n "$_ex_got" ] && [ "$_ex_got" = "$_ex_sops_version" ]; then
    log_ok "sops ${_ex_sops_version} already present (latest)"
    return 0
  fi
  # They differ. Refuse a DOWNGRADE: `latest` is a redirect, and a yanked
  # release -- or a tampered answer -- would otherwise install an older sops
  # over a newer one, with a perfectly valid checksum since it IS a genuine
  # older release. Warn and stop: this is the one thing the dropped pin bought
  # beyond reproducibility, and it is worth four lines.
  if [ -n "$_ex_got" ] && [ "$(printf '%s\n' "$_ex_got" "$_ex_sops_version" |
    sort -V | head -n1)" = "$_ex_sops_version" ]; then
    log_warn "sops: latest resolves to $_ex_sops_version, older than the installed $_ex_got -> nothing installed"
    return 0
  fi
  [ -n "$_ex_got" ] &&
    log_info "sops ${_ex_got} installed, latest is ${_ex_sops_version}"
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
  _ex_tmp="${_log_dir:?log.sh not sourced}"
  log_info "installing sops ${_ex_sops_version}…"
  _ex_fetch_verified "$_ex_url" "$_ex_asset" \
    "sops-v${_ex_sops_version}.checksums.txt" sops || return 0
  mkdir -p -- "$HOME/.local/bin"
  # Tested: the checksum proves the download, not that the copy succeeded
  # (full disk, read-only ~/.local/bin). The ✓ has to mean the binary is there.
  if install -m 0755 -- "$_ex_tmp/$_ex_asset" "$HOME/.local/bin/sops"; then
    log_ok "sops ${_ex_sops_version} installed (checksum verified)"
  else
    log_error "sops: cannot install into ~/.local/bin"
    return 1
  fi
}

# --- age-plugin-yubikey ------------------------------------------------------
# rust is already here: runtimes ran just before. --root puts the binary in
# ~/.local/bin, which env.sh exports, instead of the ~/.cargo/bin that nothing
# adds. Build headers: docs/packages.md.
_ex_install_age_plugin() {
  # ~/.local/bin too, not just the PATH: --root writes the binary there and
  # cargo never touches PATH, so a shell started before that directory existed
  # would rebuild on every run. Same fallback as mise, starship, claude and
  # sops — and the most expensive one to get wrong, this one compiles Rust.
  if command -v age-plugin-yubikey >/dev/null 2>&1; then
    log_ok "age-plugin-yubikey already present"
    return 0
  fi
  # Two hits, two messages, like _install_script: seeing "(~/.local/bin)" is
  # how you learn your PATH does not carry that directory yet.
  if [ -x "$HOME/.local/bin/age-plugin-yubikey" ]; then
    log_ok "age-plugin-yubikey already present (~/.local/bin)"
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
  _ex_fetch_verified "$_ex_url" JetBrainsMono.tar.xz SHA-256.txt "Nerd Font" ||
    return 0
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

hash -r
unset _ex_sops_version _ex_arch _ex_asset _ex_url _ex_tmp _ex_want _ex_got _ex_fontdir _ex_cargo _ex_bin
unset _fv_asset _fv_sums _fv_label
# Same rule as packages.sh: steps are sourced in the same shell.
unset -f _ex_install_lazygit _ex_fetch_verified _ex_install_sops \
  _ex_install_age_plugin _ex_install_font
