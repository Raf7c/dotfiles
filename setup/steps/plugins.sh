#!/usr/bin/env sh
# Step plugins: clone TPM (tmux). zinit has nothing to do here, it self-installs
# on the first zsh launch (.config/zsh/zinit.zsh). Since ~/.config/tmux is a
# link to the repo, TPM lands in .config/tmux/plugins/, already gitignored.

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
    log_warn "TPM: plugin install failed (network?), retry with: prefix + I"
fi

log_info "zinit: no action (self-installs on first zsh)"
