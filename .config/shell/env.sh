#!/usr/bin/env sh
# Common environment, shared by bash and zsh (POSIX syntax).
# Also the BASH_ENV target: kept MINIMAL on purpose (env + PATH only,
# nothing interactive) so non-interactive bash scripts stay predictable.

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
if [ -d "$HOME/icloud" ]; then export ICLOUD="$HOME/icloud"; fi

# ------------------ Pager / Browser ------------------
export PAGER="less"
export LESS="-R --quit-if-one-screen"
# Only when firefox is actually on the PATH (macOS: fall back to `open`).
if command -v firefox >/dev/null 2>&1; then export BROWSER="firefox"; fi

# ------------------ Tools / history files (XDG) ------------------
export LESSHISTFILE="${XDG_CACHE_HOME}/less/history"
export PYTHON_HISTORY="${XDG_DATA_HOME}/python/history"

# ------------------ PATH ------------------
# Prepend <dir> if it exists and is not already in PATH. POSIX (works
# sourced from bash AND zsh). zsh re-asserts the final order itself
# (_zsh_build_path in .zshenv / .zprofile, after `brew shellenv`).
env_path_prepend() {
  [ -d "$1" ] || return 0
  case ":$PATH:" in *":$1:"*) return 0 ;; esac
  PATH="$1:$PATH"
}
env_path_prepend "$HOME/.local/bin"
env_path_prepend "${XDG_CONFIG_HOME}/scripts"
env_path_prepend "${XDG_DATA_HOME}/mise/shims"   # mise shims first
export PATH
