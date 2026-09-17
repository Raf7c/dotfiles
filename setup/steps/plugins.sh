#!/usr/bin/env sh
# Step plugins: clone TPM (tmux), replay the yazi flavors. zinit has nothing to
# do here, it self-installs on the first zsh launch (.config/zsh/zinit.zsh).

# TPM lands INSIDE ~/.config/tmux, which symlinks points at the repo. Run alone
# before symlinks, this would clone into a real directory that symlinks later
# backs up and replaces — orphaning the clone, and reporting success. The
# dependency is documented (docs/installer.md, the steps table); enforce it.
if [ ! -L "${XDG_CONFIG_HOME:-$HOME/.config}/tmux" ]; then
  if [ "$DRY_RUN" = 1 ]; then
    # Faithful preview (docs/installer.md, contrat n°2).
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

# --- yazi flavors ---
# Same shape as TPM: `ya pkg` writes into ~/.config/yazi/flavors/, which is the
# repo through the symlink, and that directory is gitignored. `install` and not
# `add`: it replays package.toml, the versioned record of what to fetch. Adding
# a flavor is `ya pkg add <owner>/<repo>:<name>` once, then commit package.toml.
_yazi_dir="${XDG_CONFIG_HOME:-$HOME/.config}/yazi"
if [ ! -L "$_yazi_dir" ]; then
  log_info "yazi: ~/.config/yazi is not the repo link yet -> run 'symlinks' first"
elif [ ! -f "$_yazi_dir/package.toml" ]; then
  log_info "yazi: no package.toml -> flavors not declared yet, theme.toml falls back"
elif command -v ya >/dev/null 2>&1; then
  # No network is not a reason to abort: yazi runs with its built-in theme.
  run ya pkg install ||
    log_warn "yazi: flavor install failed (network?), retry with: ya pkg install"
else
  log_info "yazi: 'ya' absent -> the full run installs it, then: ./run install plugins"
fi

log_info "zinit: no action (self-installs on first zsh)"
unset _tpm_dir _yazi_dir
