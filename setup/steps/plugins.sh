#!/usr/bin/env sh
# Step plugins: clone TPM (tmux). zinit has nothing to do here, it self-installs
# on the first zsh launch (.config/zsh/zinit.zsh). Since ~/.config/tmux is a
# link to the repo, TPM lands in .config/tmux/plugins/, already gitignored.

# TPM lands INSIDE ~/.config/tmux, which symlinks points at the repo. Run alone
# before symlinks, this would clone into a real directory that symlinks later
# backs up and replaces — orphaning the clone, and reporting success. The
# dependency is documented (docs/installer.md, the steps table); enforce it.
if [ ! -L "${XDG_CONFIG_HOME:-$HOME/.config}/tmux" ]; then
  if [ "$DRY_RUN" = 1 ]; then
    # Faithful preview, same reasoning as runtimes.sh: in a real run symlinks
    # has linked ~/.config/tmux four steps earlier, so do not report a blocker
    # that only exists because the preview created nothing.
    log_info "[dry-run] plugins: assumes the FULL run, where symlinks links"
    log_info "          ~/.config/tmux first; alone and early, this step would skip"
    log_info "          then: git clone tpm -> .config/tmux/plugins/tpm"
    log_info "          then: tpm/bin/install_plugins (what tmux.conf lists)"
    return 0
  fi
  log_warn "plugins: ~/.config/tmux is not the repo link yet -> run 'symlinks' first"
  return 0
fi

# Set AFTER the guard: the two early returns above would skip the unset below.
_tpm_dir="${XDG_CONFIG_HOME:-$HOME/.config}/tmux/plugins/tpm"

if [ -d "$_tpm_dir/.git" ]; then
  log_ok "TPM already present"
else
  require_cmd git || return 0
  log_info "cloning TPM -> ${_tpm_dir#"$HOME"/}"
  # No network is not a reason to abort: tmux works without its plugins, and
  # `./run install plugins` replays this.
  run git clone --depth 1 -- https://github.com/tmux-plugins/tpm "$_tpm_dir" ||
    log_warn "TPM: clone failed (network?), tmux plugins not installed"
fi

# Install what tmux.conf lists, without opening tmux.
if command -v tmux >/dev/null 2>&1 && [ -x "$_tpm_dir/bin/install_plugins" ]; then
  run "$_tpm_dir/bin/install_plugins" ||
    log_warn "TPM: plugin install failed (network, or tmux.conf unreadable), retry with: prefix + I"
fi

log_info "zinit: no action (self-installs on first zsh)"
unset _tpm_dir
