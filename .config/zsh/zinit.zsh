#!/usr/bin/env zsh

# ------------------ Bootstrap zinit ------------------
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

if [[ ! -d "${ZINIT_HOME}" ]]; then
  mkdir -p "${ZINIT_HOME:h}"
  git clone https://github.com/zdharma-continuum/zinit.git "${ZINIT_HOME}"
fi

source "${ZINIT_HOME}/zinit.zsh"

# ------------------ Completions (BEFORE compinit) ------------------
# zsh-completions must be added to fpath before compinit
zinit light zsh-users/zsh-completions

# Homebrew completions (eza, fzf, mise…): `brew shellenv` does NOT touch
# FPATH, and the system /bin/zsh doesn't know /opt/homebrew.
[[ -d /opt/homebrew/share/zsh/site-functions ]] \
  && fpath+=(/opt/homebrew/share/zsh/site-functions)

# ------------------ compinit ------------------
autoload -Uz compinit
# compinit silently fails to write its dump if the directory is missing
# (-> slow startup every time).
[[ -d "${XDG_CACHE_HOME}/zsh" ]] || mkdir -p "${XDG_CACHE_HOME}/zsh"
compinit -d "${XDG_CACHE_HOME}/zsh/zcompdump"
# Replays compdef calls registered by plugins loaded before compinit
zinit cdreplay -q

# ------------------ Plugins ------------------
zinit light Aloxaf/fzf-tab

# Syntax highlighting + autosuggestions
zinit wait lucid for \
  zsh-users/zsh-syntax-highlighting \
  atload"_zsh_autosuggest_start" \
  zsh-users/zsh-autosuggestions

# zsh-vi-mode
# The ZVM_CURSOR_* constants are defined BY the plugin, so they must be
# referenced inside zvm_config (called automatically by the plugin),
# not before it is sourced — see README, "Configuration Function".
zvm_config() {
  ZVM_INSERT_MODE_CURSOR=$ZVM_CURSOR_BEAM
  ZVM_NORMAL_MODE_CURSOR=$ZVM_CURSOR_BLOCK
  ZVM_VISUAL_MODE_CURSOR=$ZVM_CURSOR_BLOCK
  ZVM_VI_HIGHLIGHT_BACKGROUND=none
  ZVM_VI_HIGHLIGHT_FOREGROUND=none
  ZVM_VI_HIGHLIGHT_EXTRASTYLE=none
}

zinit ice depth=1
zinit light jeffreytse/zsh-vi-mode
