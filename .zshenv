#!/usr/bin/env zsh
# ZDOTDIR bootstrap: the only hook zsh reads before ZDOTDIR exists, and the
# only one that needs no root. Full startup chain: docs/architecture.md.

export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"

# zsh will NOT read $ZDOTDIR/.zshenv by itself: it has already read a .zshenv,
# this one. Guarded, so a partial install does not error on every zsh start.
if [[ -r "${ZDOTDIR}/.zshenv" ]]; then
  source "${ZDOTDIR}/.zshenv"
fi
