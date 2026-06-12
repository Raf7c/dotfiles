#!/usr/bin/env sh
# Module: shell — ZDOTDIR bootstrap (/etc) + switch the login shell to zsh.
#
# Contract:
#   - idempotent: ZDOTDIR block added only if missing (marker);
#     chsh only if the current shell is not already zsh
#   - OS: system file via zdotdir_system_file
#         (macOS and Fedora = /etc/zshenv)
#   - sudo: YES (writing /etc and /etc/shells)
#   - order: placed AFTER packages (chsh requires zsh installed) and at the end
#     of install ("system changes last"); if zsh is missing, we skip cleanly.
#   - dry-run: handled by hand for the `sudo tee` (redirections, outside run()).

# ---------- Bootstrap ZDOTDIR in the system zshenv ----------
_sysfile=$(zdotdir_system_file 2>/dev/null || true)
if [ -z "$_sysfile" ]; then
  log_warn "OS with no known zshenv path -> ZDOTDIR skipped"
elif [ -r "$_sysfile" ] && grep -q 'dotfiles ZDOTDIR' "$_sysfile" 2>/dev/null; then
  log_ok "ZDOTDIR already configured ($_sysfile)"
elif confirm "Write the ZDOTDIR block to $_sysfile (sudo)?"; then
  if [ "$DRY_RUN" = 1 ]; then
    log_info "[dry-run] add the ZDOTDIR block to $_sysfile (sudo)"
  else
    sudo mkdir -p "$(dirname "$_sysfile")"
    printf '%s\n' \
      '' \
      '# >>> dotfiles ZDOTDIR >>>' \
      'if [ -z "${XDG_CONFIG_HOME}" ]; then export XDG_CONFIG_HOME="${HOME}/.config"; fi' \
      'if [ -d "${XDG_CONFIG_HOME}/zsh" ]; then export ZDOTDIR="${XDG_CONFIG_HOME}/zsh"; fi' \
      '# <<< dotfiles ZDOTDIR <<<' \
      | sudo tee -a "$_sysfile" >/dev/null \
      && log_ok "ZDOTDIR set in $_sysfile" \
      || log_warn "ZDOTDIR: write to $_sysfile failed (sudo refused?)"
  fi
else
  log_warn "ZDOTDIR not configured: the zsh config (.config/zsh) will not load"
fi

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
