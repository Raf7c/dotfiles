#!/usr/bin/env zsh

# A full compinit rescan costs 50-150 ms: do it at most once a day and trust
# the dump (-C) the rest of the time. `find -mtime +0` gates on 24 h.
_zsh_compinit() {
  autoload -Uz compinit
  # Keyed by host and zsh version: a shared $HOME or a zsh upgrade must never
  # reuse an incompatible dump.
  _zdump="${XDG_CACHE_HOME:-${HOME}/.cache}/zsh/zcompdump-${HOST}-${ZSH_VERSION}"
  # Without the directory compinit silently fails to write, and every startup
  # pays the full rescan.
  [[ -d "${_zdump:h}" ]] || mkdir -p -- "${_zdump:h}"
  # -i: never block startup on the "insecure directories" prompt.
  if [[ -f "${_zdump}" ]] && [[ -z "$(find "${_zdump}" -mtime +0 2>/dev/null)" ]]; then
    compinit -C -i -d "${_zdump}"
  else
    compinit -i -d "${_zdump}"
  fi
  unset _zdump
}

# ------------------ Bootstrap zinit ------------------
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# A machine without git or network must still get a working shell, degraded to
# no plugins. Test the FILE we source, not the directory: an interrupted clone
# leaves a directory that passes `-d` but has no zinit.zsh, and `git clone`
# refuses a non-empty directory, so the bootstrap would never retry. Purge it.
if [[ ! -r "${ZINIT_HOME}/zinit.zsh" ]]; then
  [[ -d "${ZINIT_HOME}" ]] && rm -rf -- "${ZINIT_HOME}"
  if ((${+commands[git]})); then
    mkdir -p -- "${ZINIT_HOME:h}"
    git clone --depth 1 -- https://github.com/zdharma-continuum/zinit.git "${ZINIT_HOME}" ||
      print -u2 "zinit: clone failed (network?), plugins skipped this session"
  else
    print -u2 "zinit: git missing, plugins skipped this session"
  fi
fi

if [[ -r "${ZINIT_HOME}/zinit.zsh" ]]; then
  # zinit reruns compinit during `zinit update`, and would write its dump at
  # the default $ZDOTDIR/.zcompdump, i.e. INSIDE this repo.
  typeset -gA ZINIT
  ZINIT[ZCOMPDUMP_PATH]="${XDG_CACHE_HOME:-${HOME}/.cache}/zsh/zcompdump-${HOST}-${ZSH_VERSION}"
  source "${ZINIT_HOME}/zinit.zsh"

  # ------------------ Completions (BEFORE compinit) ------------------
  # zsh-completions must be added to fpath before compinit
  zinit light zsh-users/zsh-completions

  # `brew shellenv` does NOT touch FPATH, and the system zsh knows nothing of
  # /opt/homebrew.
  [[ -d /opt/homebrew/share/zsh/site-functions ]] &&
    fpath+=(/opt/homebrew/share/zsh/site-functions)

  # ------------------ compinit ------------------
  _zsh_compinit
  # Replays compdef calls registered by plugins loaded before compinit
  zinit cdreplay -q

  # ------------------ Plugins ------------------
  zinit light Aloxaf/fzf-tab

  # Guarded on fzf: without it the widgets would exist and fail on use.
  ((${+commands[fzf]})) && zinit wait lucid light-mode for junegunn/fzf-git.sh

  zinit wait lucid for \
    zsh-users/zsh-syntax-highlighting \
    atload"_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions
else
  # Plain completion, so the shell stays usable without zinit.
  _zsh_compinit
fi
