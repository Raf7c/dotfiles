#!/usr/bin/env sh
# Module: plugins — shell/tmux plugin managers.
#
# - TPM (tmux): cloned explicitly (idempotent: only if missing).
# - zinit (zsh): NOTHING to do here — it self-installs on the first zsh launch
#   (see .config/zsh/zinit.zsh).
#
# Contract:
#   - idempotent: clone only if the .git directory is missing
#   - OS: all; no sudo
#   - depends on symlinks (~/.config/tmux in place) and prereqs (git)
#   - dry-run: via run()
#
# Note: since ~/.config/tmux is a link to the repo, TPM lands in
# .config/tmux/plugins/ — already git-ignored.

_tpm_dir="${XDG_CONFIG_HOME:-$HOME/.config}/tmux/plugins/tpm"

if [ -d "$_tpm_dir/.git" ]; then
  log_ok "TPM already present"
else
  require_cmd git || return 0
  log_info "cloning TPM -> ${_tpm_dir#"$HOME"/}"
  run git clone --depth 1 https://github.com/tmux-plugins/tpm "$_tpm_dir"
fi

# Install the plugins listed in tmux.conf without opening tmux (if tmux is there).
if command -v tmux >/dev/null 2>&1 && [ -x "$_tpm_dir/bin/install_plugins" ]; then
  run "$_tpm_dir/bin/install_plugins"
fi

log_info "zinit: no action (self-installs on first zsh)"
