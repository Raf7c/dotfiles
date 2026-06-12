#!/usr/bin/env sh
# Command: update — sync the machine with the repo.
# = `git pull` (fast-forward only) + replay the RECONCILING steps.
# Does NOT bump versions (that's `upgrade`'s job). Sourced by `run`.

# Update the repo (no merge or force; warn if it blocks).
log_step "repo: git pull --ff-only"
if [ "$DRY_RUN" = 1 ]; then
  run git -C "$DOTFILES_DIR" pull --ff-only
elif git -C "$DOTFILES_DIR" pull --ff-only; then
  log_ok "repo up to date"
else
  log_warn "git pull --ff-only failed (local changes / divergence?) — continuing with current state"
fi

# Replay the subset that brings the machine back in sync with the repo:
#    submodules (sync to the pinned commit), new directories, new links,
#    new packages, new runtimes, new tmux plugins.
#    (prereqs / migrate / shell are one-time -> not replayed.)
run_steps submodules directories symlinks packages runtimes plugins

log_step "update done."
