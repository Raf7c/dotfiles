#!/usr/bin/env sh
# Module: shell — switch the login shell to zsh.
#
# ZDOTDIR is NOT bootstrapped here any more. It used to be written into
# /etc/zshenv with sudo, which had three defects:
#   - it made the whole zsh config depend on root: no sudo, no config;
#   - /etc/zshenv is read by EVERY zsh of EVERY user, so the block leaked
#     ZDOTDIR (and XDG_CONFIG_HOME) into other accounts;
#   - /etc/zshenv is read even by `zsh -f`, so a shell meant to be pristine
#     was not.
# The bootstrap now lives in ~/.zshenv, linked from this repo by the
# symlinks step (see setup/manifest.sh). Single source of truth, no root.
# Existing machines: remove the old block, see the Uninstall section of the
# README.
#
# Contract:
#   - idempotent: chsh only if the current shell is not already zsh
#   - OS: all
#   - sudo: only to append to /etc/shells, and only if chsh is accepted
#   - order: placed AFTER packages (chsh requires zsh installed) and at the end
#     of install ("system changes last"); if zsh is missing, we skip cleanly.
#   - dry-run: handled by hand for the `sudo tee` (redirections, outside run()).

# ---------- Login shell = zsh ----------
_zsh=$(command -v zsh 2>/dev/null || true)
if [ -z "$_zsh" ]; then
  log_warn "zsh missing -> chsh skipped (install zsh via packages first)"
elif [ "${SHELL##*/}" = zsh ]; then
  log_ok "login shell already zsh"
elif confirm "Make zsh ($_zsh) the login shell (chsh)?"; then
  if [ "$DRY_RUN" = 1 ]; then
    log_info "[dry-run] add $_zsh to /etc/shells if needed + chsh -s $_zsh"
  else
    { grep -qx "$_zsh" /etc/shells 2>/dev/null \
      || printf '%s\n' "$_zsh" | sudo tee -a /etc/shells >/dev/null; } \
      || log_warn "/etc/shells: write failed (sudo refused?)"
    chsh -s "$_zsh" || log_warn "chsh failed (password?)"
    log_ok "login shell -> zsh (takes effect next session)"
  fi
else
  log_warn "login shell unchanged"
fi
