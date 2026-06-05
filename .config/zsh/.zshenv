#!/usr/bin/env zsh

# ------------------ XDG Base Directories ------------------
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

# ------------------ Editor / locale ------------------
export EDITOR="nvim"
export VISUAL="$EDITOR"
export GIT_EDITOR="$EDITOR"
export LANG="en_US.UTF-8"

# ------------------ Repos / personal paths ------------------
export GITUSER="raf7c"
export REPOS="$HOME/lab"
export GHREPOS="$REPOS/github"
export GLREPOS="$REPOS/gitlab"
export DOTFILES="$HOME/.dotfiles"
[[ -d "$HOME/icloud" ]] && export ICLOUD="$HOME/icloud"

# ------------------ Pager / Browser ------------------
export PAGER="less"
export LESS="-R --quit-if-one-screen"
export BROWSER="firefox"

# ------------------ Tools / history files (XDG) ------------------
export ASDF_DATA_DIR="${XDG_DATA_HOME}/asdf"
export LESSHISTFILE="${XDG_CACHE_HOME}/less/history"
export PYTHON_HISTORY="${XDG_DATA_HOME}/python/history"

# ------------------ PATH ------------------
# Defined here (so also available in .zprofile, read after) to avoid
# duplicating the path list. -g: modifies the global param from within the function.
# -U: deduplicates keeping the first occurrence. (N-/): removes non-existent
# directories. Called again in .zprofile to reassert order AFTER `brew shellenv`.
_zsh_build_path() {
  typeset -gU path PATH
  path=(
    ${ASDF_DATA_DIR}/shims        # versions managed by asdf (highest priority)
    ${XDG_CONFIG_HOME}/scripts    # personal scripts
    $HOME/.local/bin              # user binaries (XDG)
    $path                         # existing entries (system…)
  )
  path=($^path(N-/))
}
_zsh_build_path
export PATH
