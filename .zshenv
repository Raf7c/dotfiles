#!/usr/bin/env zsh
# ZDOTDIR bootstrap. The only hook available WITHOUT root before ZDOTDIR
# exists, so the only way to point zsh at ~/.config/zsh without writing to /etc.
# Full startup chain: docs/architecture.md.

export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"

# zsh will NOT read $ZDOTDIR/.zshenv by itself: it has already read a .zshenv,
# this one. Guarded, so a partial install does not error on every zsh start.
if [[ -r "${ZDOTDIR}/.zshenv" ]]; then
  source "${ZDOTDIR}/.zshenv"
fi
