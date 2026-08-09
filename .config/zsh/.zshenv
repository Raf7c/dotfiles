#!/usr/bin/env zsh

# Common environment (XDG, EDITOR, history files…) shared with bash:
# one single source of truth, POSIX syntax.
# Guarded: .zshenv is read by every zsh, scripts included. A partial install
# would otherwise error on every invocation and pollute every script's stdout.
_env="${XDG_CONFIG_HOME:-$HOME/.config}/shell/env.sh"
[[ -r "$_env" ]] && source "$_env"
unset _env

# ------------------ PATH ------------------
# env.sh already prepended what's needed; this function RE-ASSERTS our
# order (mise shims first) and dedups. -g: modifies the global param from
# within the function. -U: deduplicates keeping the first occurrence.
# (N-/): removes non-existent directories. Called again in .zprofile to
# reassert order AFTER `brew shellenv`.
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
