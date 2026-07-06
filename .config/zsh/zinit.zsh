#!/usr/bin/env zsh

# compinit: a FULL rescan of every completion function costs 50-150 ms.
# Do it at most once a day; the rest of the time trust the dump (-C).
# `find -mtime +0` prints the dump only if it is older than 24 h.
_zsh_compinit() {
  autoload -Uz compinit
  _zdump="${XDG_CACHE_HOME}/zsh/zcompdump"
  # compinit silently fails to write its dump if the directory is missing
  # (-> slow startup every time).
  [[ -d "${_zdump:h}" ]] || mkdir -p "${_zdump:h}"
  if [[ -f "${_zdump}" ]] && [[ -z "$(find "${_zdump}" -mtime +0 2>/dev/null)" ]]; then
    compinit -C -d "${_zdump}"
  else
    compinit -d "${_zdump}"
  fi
  unset _zdump
}

# ------------------ Bootstrap zinit ------------------
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Guarded: a fresh machine without git or network must still get a working
# shell (degraded: no plugins), never startup errors.
if [[ ! -d "${ZINIT_HOME}" ]]; then
  if (( ${+commands[git]} )); then
    mkdir -p "${ZINIT_HOME:h}"
    git clone -- https://github.com/zdharma-continuum/zinit.git "${ZINIT_HOME}" \
      || print -u2 "zinit: clone failed (network?) — plugins skipped this session"
  else
    print -u2 "zinit: git missing — plugins skipped this session"
  fi
fi

if [[ -r "${ZINIT_HOME}/zinit.zsh" ]]; then
  source "${ZINIT_HOME}/zinit.zsh"

  # ------------------ Completions (BEFORE compinit) ------------------
  # zsh-completions must be added to fpath before compinit
  zinit light zsh-users/zsh-completions

  # Homebrew completions (eza, fzf, mise…): `brew shellenv` does NOT touch
  # FPATH, and the system /bin/zsh doesn't know /opt/homebrew.
  [[ -d /opt/homebrew/share/zsh/site-functions ]] \
    && fpath+=(/opt/homebrew/share/zsh/site-functions)

  # ------------------ compinit ------------------
  _zsh_compinit
  # Replays compdef calls registered by plugins loaded before compinit
  zinit cdreplay -q

  # ------------------ Plugins ------------------
  zinit light Aloxaf/fzf-tab

  # Syntax highlighting + autosuggestions
  zinit wait lucid for \
    zsh-users/zsh-syntax-highlighting \
    atload"_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions
else
  # Fallback: plain completion so the shell stays fully usable without zinit.
  _zsh_compinit
fi
