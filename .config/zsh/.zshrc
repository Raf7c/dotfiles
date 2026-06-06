#!/usr/bin/env zsh

# ------------------ History ------------------
HISTFILE="${XDG_STATE_HOME}/zsh/history"
HISTSIZE=100000
SAVEHIST=100000

setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS

# ------------------ Shell behaviour ------------------
setopt AUTOCD
setopt NOBEEP
setopt NUMERIC_GLOB_SORT

# ------------------ SSH ------------------
export GPG_TTY="$(tty)"



source "${ZDOTDIR}/zinit.zsh"

# ------------------ Completion zstyle ------------------
zstyle ':completion::complete:*' cache-path "${XDG_CACHE_HOME}/zsh/zcompcache"
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no

# Reuse ls completion for eza
compdef eza=ls

# fzf-tab preview
if command -v eza >/dev/null 2>&1; then
  zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always --icons $realpath 2>/dev/null'
  if command -v zoxide >/dev/null 2>&1; then
    zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza -1 --color=always --icons $realpath 2>/dev/null'
  fi
else
  zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color=always $realpath 2>/dev/null'
fi

zstyle ':fzf-tab:complete:*:*' fzf-preview 'less ${(Q)realpath} 2>/dev/null'

# fzf-tab behaviour
zstyle ':fzf-tab:*' fzf-min-height 20
zstyle ':fzf-tab:*' switch-group '<' '>'
zstyle ':fzf-tab:*' fzf-bindings 'tab:down'

# Register zinit completion
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# ------------------ Modular Config ------------------
source "${XDG_CONFIG_HOME}/shell/aliases.sh"
source "${ZDOTDIR}/fzf.zsh"                    # fzf variables + widget (zsh)

# ------------------ Tools init ------------------
if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh)"
  source <(mise completion zsh)
fi
eval "$(zoxide init zsh)"
eval "$(starship init zsh)"

# fzf rebinds Ctrl-R/Ctrl-T/Alt-C. zsh-vi-mode resets keymaps in
# its zvm_after_init hook -> re-register fzf + our bindings AFTER, otherwise
# they get overwritten.
zvm_after_init_commands+=(
  'eval "$(fzf --zsh)"'
  'bindkey "^F" _fzf_file_no_hidden'
)
