#!/usr/bin/env zsh

# Common environment (XDG, EDITOR, history files…) shared with bash:
# one single source of truth, POSIX syntax.
source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/env.sh"

# ------------------ PATH ------------------
# env.sh already prepended what's needed; this function RE-ASSERTS our
# order (mise shims first) and dedups. -g: modifies the global param from
# within the function. -U: deduplicates keeping the first occurrence.
# (N-/): removes non-existent directories. Called again in .zprofile to
# reassert order AFTER `brew shellenv`.
_zsh_build_path() {
  typeset -gU path PATH
  path=(
    ${XDG_DATA_HOME}/mise/shims   # mise shims (highest priority)
    ${XDG_CONFIG_HOME}/scripts    # personal scripts
    $HOME/.local/bin              # user binaries (XDG)
    $path                         # existing entries (system…)
  )
  path=($^path(N-/))
}
_zsh_build_path
export PATH
