#!/usr/bin/env sh
# Command upgrade: bump tool versions. Touches no dotfiles STRUCTURE and runs
# no git pull -- that is install/update. A failure on one tool does not stop
# the others, and each block announces itself so an interrupt shows where.

# --- Package manager ---
log_step "upgrade: system packages"
if command -v brew >/dev/null 2>&1; then
  run brew update || log_warn "brew update: failed"
  run brew upgrade || log_warn "brew upgrade: partial failure"
  run brew cleanup || true
else
  log_warn "brew missing -> package update skipped"
fi

# --- mise (runtimes, within the limits of ~/.config/mise/config.toml) ---
log_step "upgrade: mise runtimes"
if command -v mise >/dev/null 2>&1; then
  # The mise BINARY comes from `brew upgrade` above; this bumps the runtimes
  # it manages, within the limits of .config/mise/config.toml.
  run mise upgrade || log_warn "mise upgrade: failed"
  # Invalidate the cached completions: regenerated at the next shell start.
  # `|| true` because THIS file runs with `set -e` active, unlike a step: a
  # failing rm here would kill run before log_summary. See docs/installer.md.
  run rm -f -- "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/mise-completion.zsh" \
    "${XDG_CACHE_HOME:-$HOME/.cache}/bash/mise-completion.bash" || true
else
  # log_info under --dry-run: a preview must not report a warning about the
  # machine it previews on.
  if [ "$DRY_RUN" = 1 ]; then
    log_info "[dry-run] mise missing here -> the runtime block would be skipped"
  else
    log_warn "mise missing -> runtime update skipped"
  fi
fi

# --- Claude Code (native installer; self-updates, but stay explicit) ---
log_step "upgrade: claude code"
if command -v claude >/dev/null 2>&1; then
  run claude update || log_warn "claude update: failed"
else
  log_info "claude code not installed -> skipped"
fi

# --- zinit (zsh): self-update + plugins ---
log_step "upgrade: zinit"
_zinit="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git/zinit.zsh"
if [ -r "$_zinit" ] && command -v zsh >/dev/null 2>&1; then
  # -f: no startup file, so upgrade does not depend on .zshrc being healthy.
  # It still INHERITS ZDOTDIR, hence ZCOMPDUMP_PATH: without it zinit's own
  # compinit drops its dump inside the repo.
  # cclear last, and it belongs HERE: the plugins follow HEAD, so an update
  # that drops a completion upstream leaves a dangling symlink behind, and
  # compinit then prints "no such file or directory" on EVERY shell start.
  run zsh -fc "typeset -gA ZINIT; ZINIT[ZCOMPDUMP_PATH]=\"${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-\${HOST}-\${ZSH_VERSION}\"; source '$_zinit'; zinit self-update; zinit update --all; zinit cclear" ||
    log_warn "zinit: update failed"
else
  log_info "zinit not installed -> skipped (installs on first zsh)"
fi

# --- TPM (tmux): update plugins without opening tmux ---
log_step "upgrade: TPM"
_tpm="${XDG_CONFIG_HOME:-$HOME/.config}/tmux/plugins/tpm"
if [ -x "$_tpm/bin/update_plugins" ]; then
  run "$_tpm/bin/update_plugins" all || log_warn "TPM: update failed"
else
  log_info "TPM not installed -> skipped"
fi

# --- git submodules (nvim): bump to the LATEST remote commit ---
log_step "upgrade: submodules"
# `update` resyncs to the pinned commit instead. The pointer moves in the repo:
# commit afterwards to freeze it.
if [ -f "$DOTFILES_DIR/.gitmodules" ]; then
  run git -C "$DOTFILES_DIR" submodule update --remote --recursive --merge ||
    log_warn "submodule --remote: failed"
else
  log_info "no .gitmodules -> skipped"
fi

log_step "upgrade done."
log_summary upgrade || exit 1
