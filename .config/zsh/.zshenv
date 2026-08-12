#!/usr/bin/env zsh

# The environment shared with bash, one source of truth in POSIX syntax.
# Guarded: this file is read by every zsh, scripts included, and a partial
# install would otherwise pollute every script's stdout.
_env="${XDG_CONFIG_HOME:-$HOME/.config}/shell/env.sh"
[[ -r "$_env" ]] && source "$_env"
unset _env

# ------------------ PATH ------------------
# Re-asserts our order after env.sh, and again in .zprofile after
# `brew shellenv`. -U dedups keeping the first occurrence, (N-/) drops
# directories that do not exist. See docs/architecture.md, the PATH story.
_zsh_build_path() {
  typeset -gU path PATH
  path=(
    ${XDG_DATA_HOME:-$HOME/.local/share}/mise/shims # mise shims (highest priority)
    ${XDG_CONFIG_HOME:-$HOME/.config}/scripts       # personal scripts
    $HOME/.local/bin                                # user binaries (XDG)
    $path                                           # existing entries (system…)
  )
  path=($^path(N-/))
}
_zsh_build_path
export PATH
