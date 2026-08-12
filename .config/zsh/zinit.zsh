#!/usr/bin/env zsh

# compinit: a FULL rescan of every completion function costs 50-150 ms.
# Do it at most once a day; the rest of the time trust the dump (-C).
# `find -mtime +0` prints the dump only if it is older than 24 h.
_zsh_compinit() {
  autoload -Uz compinit
  # Keyed by host and zsh version: a shared (NFS) $HOME or a zsh upgrade
  # must never reuse an incompatible dump. :- default: survive without env.sh.
  _zdump="${XDG_CACHE_HOME:-${HOME}/.cache}/zsh/zcompdump-${HOST}-${ZSH_VERSION}"
  # compinit silently fails to write its dump if the directory is missing
  # (-> slow startup every time).
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

# Guarded: a fresh machine without git or network must still get a working
# shell (degraded: no plugins), never startup errors.
# Test the FILE we are going to source, not just the directory: an
# interrupted clone (Ctrl-C, network drop) leaves a directory that passes
# `-d` but has no zinit.zsh: the bootstrap would then never retry, and
# `git clone` into a non-empty directory refuses to run anyway. Purge it.
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
  # zinit reruns compinit itself during `zinit update`; without this it
  # writes the dump at the DEFAULT location, $ZDOTDIR/.zcompdump, i.e.
  # inside this repo. Point it at the same XDG path _zsh_compinit uses.
  typeset -gA ZINIT
  ZINIT[ZCOMPDUMP_PATH]="${XDG_CACHE_HOME:-${HOME}/.cache}/zsh/zcompdump-${HOST}-${ZSH_VERSION}"
  source "${ZINIT_HOME}/zinit.zsh"

  # ------------------ Completions (BEFORE compinit) ------------------
  # zsh-completions must be added to fpath before compinit
  zinit light zsh-users/zsh-completions

  # Homebrew completions (eza, fzf, mise…): `brew shellenv` does NOT touch
  # FPATH, and the system /bin/zsh doesn't know /opt/homebrew.
  [[ -d /opt/homebrew/share/zsh/site-functions ]] &&
    fpath+=(/opt/homebrew/share/zsh/site-functions)

  # ------------------ compinit ------------------
  _zsh_compinit
  # Replays compdef calls registered by plugins loaded before compinit
  zinit cdreplay -q

  # ------------------ Plugins ------------------
  zinit light Aloxaf/fzf-tab

  # fzf-git.sh: CTRL-G widgets over git objects. Guarded on fzf: without
  # it the widgets would exist and fail on use.
  ((${+commands[fzf]})) && zinit wait lucid light-mode for junegunn/fzf-git.sh

  zinit wait lucid for \
    zsh-users/zsh-syntax-highlighting \
    atload"_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions
else
  # Fallback: plain completion so the shell stays fully usable without zinit.
  _zsh_compinit
fi
