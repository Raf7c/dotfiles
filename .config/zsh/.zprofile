#!/usr/bin/env zsh


# ------------------ Homebrew (macOS) ------------------
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
  export HOMEBREW_NO_AUTO_UPDATE=1
  export HOMEBREW_NO_ANALYTICS=1
fi

# brew just prepended the PATH; reassert our priorities (asdf shims first)
# by reusing the function defined in .zshenv — no duplicated list.
_zsh_build_path
export PATH
