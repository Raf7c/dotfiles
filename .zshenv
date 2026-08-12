#!/usr/bin/env zsh
# ~/.zshenv: ZDOTDIR bootstrap, WITHOUT sudo.
#
# zsh reads this file (as $ZDOTDIR/.zshenv, ZDOTDIR defaulting to $HOME) on
# EVERY invocation: login, interactive and scripts. It is the only hook that
# exists before ZDOTDIR does, hence the only way to point zsh at
# ~/.config/zsh without writing to /etc, see setup/steps/shell.sh, which
# needs sudo and affects every user of the machine.
#
# If /etc/zshenv already sets ZDOTDIR, zsh reads $ZDOTDIR/.zshenv directly
# and never opens this file: no double loading in either case.

export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"

# The real environment lives in $ZDOTDIR/.zshenv, which zsh will NOT read by
# itself: it has already read a .zshenv (this one). Load it here.
# Guarded: a partial install must not error on every zsh start, scripts
# included.
if [[ -r "${ZDOTDIR}/.zshenv" ]]; then
  source "${ZDOTDIR}/.zshenv"
fi
