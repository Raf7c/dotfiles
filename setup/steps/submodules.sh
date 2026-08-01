#!/usr/bin/env sh
# Module: submodules — initialize/sync the repo's git submodules
#
# Contract:
#   - idempotent: `submodule update --init` is a no-op if already up to date;
#     branch attach is skipped when already on the right branch
#   - OS: all; no sudo
#   - depends on prereqs (git); runs BEFORE symlinks (so the submodule
#     directory is populated when we link it)
#   - reconcilable: replayed by `update` (resync to the repo's commit after pull)
#   - requires access to the submodule remote (SSH/HTTPS configured)
#   - dry-run: via run() for the sync; handled by hand for the branch attach

if [ -f "$DOTFILES_DIR/.gitmodules" ]; then
  # Needs the submodule remote (network + SSH keys). A failure here must be
  # REPORTED, not abort the whole install through `set -e`: the rest of the
  # dotfiles installs fine without the nvim config, and `./run update`
  # replays this step.
  if run git -C "$DOTFILES_DIR" submodule update --init --recursive; then
    log_ok "submodules synced (pinned commit)"
  else
    log_error "submodule update failed (network / SSH access?) — step stopped"
    return 0
  fi

  # `submodule update` leaves a DETACHED HEAD: committing from inside the
  # submodule (editing the nvim config) is then easy to get wrong. Re-attach
  # each submodule to the branch declared in .gitmodules (`branch = …`):
  #   - branch behind the pinned commit -> fast-forward to it
  #   - branch ahead (local work)       -> left untouched, informative log
  git -C "$DOTFILES_DIR" config -f "$DOTFILES_DIR/.gitmodules" \
    --get-regexp '^submodule\..*\.path$' 2>/dev/null |
    while read -r _key _path; do
      _name=${_key#submodule.}
      _name=${_name%.path}
      _branch=$(git -C "$DOTFILES_DIR" config -f "$DOTFILES_DIR/.gitmodules" \
        "submodule.$_name.branch" 2>/dev/null) || continue
      _dir="$DOTFILES_DIR/$_path"
      [ -e "$_dir/.git" ] || continue
      if [ "$DRY_RUN" = 1 ]; then
        log_info "[dry-run] attach $_path to branch $_branch (ff to pinned commit if behind)"
        continue
      fi
      _cur=$(git -C "$_dir" symbolic-ref -q --short HEAD 2>/dev/null || true)
      if [ "$_cur" = "$_branch" ]; then
        log_ok "submodule $_path already on $_branch"
        continue
      fi
      _pin=$(git -C "$_dir" rev-parse HEAD 2>/dev/null) || continue
      git -C "$_dir" checkout -q "$_branch" 2>/dev/null ||
        git -C "$_dir" checkout -q -b "$_branch" "origin/$_branch" 2>/dev/null ||
        {
          log_warn "submodule $_path: cannot attach branch $_branch"
          continue
        }
      git -C "$_dir" merge --ff-only -q "$_pin" 2>/dev/null ||
        log_info "submodule $_path: $_branch ahead of pinned commit -> kept as is"
      log_ok "submodule $_path -> branch $_branch"
    done
else
  log_info "no submodule (.gitmodules missing) — nothing to do"
fi
