#!/usr/bin/env sh
# Command update: `git pull --ff-only` then replay the reconciling steps.
# Does NOT bump versions, that is `upgrade`. See docs/installer.md.

# Update the repo (no merge or force; warn if it blocks).
log_step "repo: git pull --ff-only"
if [ "$DRY_RUN" = 1 ]; then
  run git -C "$DOTFILES_DIR" pull --ff-only
elif git -C "$DOTFILES_DIR" pull --ff-only; then
  log_ok "repo up to date"
else
  log_warn "git pull --ff-only failed (local changes / divergence?), continuing with current state"
fi

# prereqs / migrate / shell are one-time. gitsign stays out too: a key added
# later needs `./run install gitsign` by hand (docs/installer.md).
run_steps submodules directories symlinks packages runtimes plugins

log_step "update done."
log_summary update || exit 1
