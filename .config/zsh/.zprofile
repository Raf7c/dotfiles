#!/usr/bin/env zsh

if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
  export HOMEBREW_NO_AUTO_UPDATE=1
  export HOMEBREW_NO_ANALYTICS=1
fi

# brew just prepended the PATH: reassert our order, no duplicated list.
_zsh_build_path
export PATH
