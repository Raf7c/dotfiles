#!/usr/bin/env bash

# ===================== XDG Base Directories =====================
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

export EDITOR="nvim"
export VISUAL="$EDITOR"
export GIT_EDITOR="$EDITOR"
export LANG="en_US.UTF-8"

export GITUSER="raf7c"
export REPOS="$HOME/lab"
export GHREPOS="$REPOS/github"
export GLREPOS="$REPOS/gitlab"
export DOTFILES="$HOME/.dotfiles"
[[ -d "$HOME/icloud" ]] && export ICLOUD="$HOME/icloud"

export PAGER="less"
export LESS="-R --quit-if-one-screen"
export BROWSER="firefox"

export LESSHISTFILE="${XDG_CACHE_HOME}/less/history"
export PYTHON_HISTORY="${XDG_DATA_HOME}/python/history"

# Non-interactive bash shells (scripts, `ssh host cmd`) reload this file:
# env + PATH are available everywhere.
export BASH_ENV="$HOME/.bashrc"

# ===================== PATH =====================
# Prepend <dir>, removing any existing occurrence (dedup + re-prioritize).
path_prepend() {
  [[ -d "$1" ]] || return
  local new p IFS=:
  for p in $PATH; do
    [[ "$p" == "$1" ]] && continue
    new="${new:+$new:}$p"
  done
  PATH="$1${new:+:$new}"
}
path_prepend "$HOME/.local/bin"
path_prepend "${XDG_CONFIG_HOME}/scripts"
path_prepend "${XDG_DATA_HOME}/mise/shims"   # shims mise en tête

# Homebrew (macOS): login shell only, then reassert path order.
if shopt -q login_shell && [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
  export HOMEBREW_NO_AUTO_UPDATE=1
  export HOMEBREW_NO_ANALYTICS=1
  path_prepend "$HOME/.local/bin"
  path_prepend "${XDG_CONFIG_HOME}/scripts"
  path_prepend "${XDG_DATA_HOME}/mise/shims"
fi
export PATH

# ===================== Beyond: interactive only =====================
case $- in *i*) ;; *) return ;; esac

# ------------------ History ------------------
export HISTFILE="${XDG_STATE_HOME}/bash/history"
mkdir -p "${HISTFILE%/*}"
HISTSIZE=100000
HISTFILESIZE=100000
HISTCONTROL=ignoreboth:erasedups
HISTTIMEFORMAT='%F %T '
shopt -s histappend
shopt -s cmdhist
shopt -s checkwinsize          # keep LINES/COLUMNS up to date on resize
# Share history across sessions (equiv. to SHARE_HISTORY in zsh). Idempotent.
case "${PROMPT_COMMAND:-}" in
  *"history -a"*) ;;
  *) PROMPT_COMMAND="history -a${PROMPT_COMMAND:+; $PROMPT_COMMAND}" ;;
esac

# ------------------ GPG ------------------
export GPG_TTY="$(tty)"

# ------------------ Completion ------------------
if [[ -r /opt/homebrew/etc/profile.d/bash_completion.sh ]]; then
  source /opt/homebrew/etc/profile.d/bash_completion.sh
elif [[ -r /usr/share/bash-completion/bash_completion ]]; then
  source /usr/share/bash-completion/bash_completion
fi
# mise : Active mise (tools/environment per project) + completion. Keeps first boot.
if command -v mise >/dev/null; then
  eval "$(mise activate bash)"
  source <(mise completion bash)
fi

# ------------------ Aliases ------------------
source "${XDG_CONFIG_HOME}/shell/aliases.sh"

# ------------------ Tools init ------------------
eval "$(starship init bash)"
