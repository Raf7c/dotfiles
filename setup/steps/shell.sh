#!/usr/bin/env sh
# Step shell: switch the login shell to zsh. ZDOTDIR is bootstrapped from
# ~/.zshenv, not /etc/zshenv: no root, no leak into other users, `zsh -f` stays
# pristine. Last step on purpose: system changes come last.

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
    { grep -qx "$_zsh" /etc/shells 2>/dev/null ||
      printf '%s\n' "$_zsh" | sudo tee -a /etc/shells >/dev/null; } ||
      log_warn "/etc/shells: write failed (sudo refused?)"
    chsh -s "$_zsh" || log_warn "chsh failed (password?)"
    log_ok "login shell -> zsh (takes effect next session)"
  fi
else
  log_warn "login shell unchanged"
fi
