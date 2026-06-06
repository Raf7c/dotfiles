#!/usr/bin/env bash

if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
  export HOMEBREW_NO_AUTO_UPDATE=1
  export HOMEBREW_NO_ANALYTICS=1
fi

# Toute la config commune + interactive :
[[ -r ~/.bashrc ]] && source ~/.bashrc
