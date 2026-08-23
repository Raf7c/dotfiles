#!/usr/bin/env sh
# Step shell: switch the login shell to zsh. ZDOTDIR is bootstrapped from
# ~/.zshenv, not /etc/zshenv: no root, no leak into other users, `zsh -f` stays
# pristine. Last step on purpose: system changes come last.

# ---------- Login shell = zsh ----------
# $SHELL is the shell that STARTED this process, not the account's login shell:
# an `exec zsh`, or a terminal's "run command", makes the two disagree, and this
# step would then print a green tick without having checked anything. Ask the
# account database; fall back to $SHELL where neither tool answers.
if is_macos; then
  _login_shell=$(dscl . -read "/Users/$(id -un)" UserShell 2>/dev/null | awk '{print $2}')
else
  _login_shell=$(getent passwd "$(id -u)" 2>/dev/null | cut -d: -f7)
fi
[ -n "$_login_shell" ] || _login_shell="${SHELL:-}"

_zsh=$(command -v zsh 2>/dev/null || true)
if [ -z "$_zsh" ]; then
  if [ "$DRY_RUN" = 1 ]; then
    # Faithful preview, same reasoning as runtimes and plugins: in a real run
    # packages installs zsh five steps earlier, so do not report a blocker the
    # preview itself created.
    log_info "[dry-run] chsh to zsh — assumes the FULL run, where packages"
    log_info "          installs zsh first; alone, this step would skip"
    return 0
  fi
  log_warn "zsh missing -> chsh skipped (install zsh via packages first)"
elif [ "${_login_shell##*/}" = zsh ]; then
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

unset _zsh _login_shell
