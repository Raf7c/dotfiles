#!/usr/bin/env sh
# Command upgrade: bump the versions of installed tools.
# Does NOT touch the dotfiles structure (that's install/update); no git pull.
# Tolerant: a failure on one tool does not stop the others. Sourced by `run`.

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
  # The heaviest action of the repo (full system upgrade, kernel included)
  # asks first: chsh does, this must too. -y/--dry-run answer yes already.
  if confirm "Upgrade every system package (sudo dnf upgrade)?"; then
    run sudo dnf upgrade --refresh -y || log_warn "dnf upgrade: failed"
  fi
fi

# --- mise (runtimes, within the limits of ~/.config/mise/config.toml) ---
if command -v mise >/dev/null 2>&1; then
  # On macOS the mise binary is updated by brew; elsewhere it self-updates.
  is_macos || run mise self-update || log_warn "mise self-update: failed"
  run mise upgrade || log_warn "mise upgrade: failed"
  # Invalidate the cached shell completions (see .zshrc/.bashrc): they are
  # regenerated at the next shell start with the fresh mise.
  run rm -f -- "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/mise-completion.zsh" \
    "${XDG_CACHE_HOME:-$HOME/.cache}/bash/mise-completion.bash"
else
  log_warn "mise missing -> runtime update skipped"
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
  # -f: skip every startup file. -i would source the whole interactive
  # config (compinit, plugins, tools) with no terminal attached: slow,
  # side effects, and upgrade would then depend on .zshrc being healthy.
  # -f skips startup files but INHERITS the exported ZDOTDIR: without
  # ZCOMPDUMP_PATH, zinit's own compinit would drop its dump inside the
  # repo ($ZDOTDIR). Same path expression as zinit.zsh.
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

# --- git submodules (e.g. nvim): bump to the LATEST remote commit ---
# (unlike `update` which resyncs to the pinned commit). The submodule pointer
# changes in the repo -> commit afterwards if you want to freeze it.
if [ -f "$DOTFILES_DIR/.gitmodules" ]; then
  run git -C "$DOTFILES_DIR" submodule update --remote --recursive --merge ||
    log_warn "submodule --remote: failed"
fi

log_step "upgrade done."
log_summary upgrade || exit 1
