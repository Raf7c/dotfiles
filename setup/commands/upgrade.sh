#!/usr/bin/env sh
# Command upgrade: bump tool versions. Touches no dotfiles STRUCTURE (links,
# directories: that is install/update) and runs no git pull. A failure on one
# tool does not stop the others.

# --- Package manager ---
if is_macos; then
  if command -v brew >/dev/null 2>&1; then
    run brew update || log_warn "brew update: failed"
    run brew upgrade || log_warn "brew upgrade: partial failure"
    run brew cleanup || true
  else
    log_warn "brew missing -> macOS package update skipped"
  fi
else
  # A full system upgrade, kernel included: it asks first, like chsh does.
  if confirm "Upgrade every system package (sudo dnf upgrade)?"; then
    run sudo dnf upgrade --refresh -y || log_warn "dnf upgrade: failed"
  fi
fi

# --- mise (runtimes, within the limits of ~/.config/mise/config.toml) ---
if command -v mise >/dev/null 2>&1; then
  # On macOS the mise binary is updated by brew; elsewhere it self-updates.
  is_macos || run mise self-update || log_warn "mise self-update: failed"
  run mise upgrade || log_warn "mise upgrade: failed"
  # Invalidate the cached completions: regenerated at the next shell start.
  run rm -f -- "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/mise-completion.zsh" \
    "${XDG_CACHE_HOME:-$HOME/.cache}/bash/mise-completion.bash"
else
  log_warn "mise missing -> runtime update skipped"
fi

# --- age-plugin-yubikey (extras step; cargo never re-installs on its own) ---
# The other three extras are pinned or inert: sops moves when its version is
# bumped in setup/steps/extras.sh and committed, the font is an unpacked
# archive, lazygit rides `dnf upgrade` above.
if command -v age-plugin-yubikey >/dev/null 2>&1; then
  _up_cargo=$(command -v cargo 2>/dev/null ||
    printf '%s' "${XDG_DATA_HOME:-$HOME/.local/share}/mise/shims/cargo")
  if [ -x "$_up_cargo" ]; then
    run "$_up_cargo" install --force --root "$HOME/.local" age-plugin-yubikey ||
      log_warn "age-plugin-yubikey: upgrade failed"
  else
    log_warn "age-plugin-yubikey: no cargo, upgrade skipped"
  fi
  unset _up_cargo
fi

# --- Claude Code (native installer; self-updates, but stay explicit) ---
if command -v claude >/dev/null 2>&1; then
  run claude update || log_warn "claude update: failed"
else
  log_info "claude code not installed -> skipped"
fi

# --- zinit (zsh): self-update + plugins ---
_zinit="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git/zinit.zsh"
if [ -r "$_zinit" ] && command -v zsh >/dev/null 2>&1; then
  # -f: no startup file. -i would source the whole interactive config with no
  # terminal attached, and make upgrade depend on .zshrc being healthy.
  # -f still INHERITS the exported ZDOTDIR, so without ZCOMPDUMP_PATH zinit's
  # own compinit drops its dump inside the repo. Same path as zinit.zsh.
  run zsh -fc "typeset -gA ZINIT; ZINIT[ZCOMPDUMP_PATH]=\"${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-\${HOST}-\${ZSH_VERSION}\"; source '$_zinit'; zinit self-update; zinit update --all" ||
    log_warn "zinit: update failed"
else
  log_info "zinit not installed -> skipped (installs on first zsh)"
fi

# --- TPM (tmux): update plugins without opening tmux ---
_tpm="${XDG_CONFIG_HOME:-$HOME/.config}/tmux/plugins/tpm"
if [ -x "$_tpm/bin/update_plugins" ]; then
  run "$_tpm/bin/update_plugins" all || log_warn "TPM: update failed"
else
  log_info "TPM not installed -> skipped"
fi

# --- git submodules (nvim): bump to the LATEST remote commit ---
# `update` resyncs to the pinned commit instead. The pointer moves in the repo:
# commit afterwards to freeze it.
if [ -f "$DOTFILES_DIR/.gitmodules" ]; then
  run git -C "$DOTFILES_DIR" submodule update --remote --recursive --merge ||
    log_warn "submodule --remote: failed"
fi

log_step "upgrade done."
log_summary upgrade || exit 1
