#!/usr/bin/env zsh

# --- History ---
# :- default: an empty XDG_STATE_HOME would send the history to /zsh/history.
HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
HISTSIZE=100000
SAVEHIST=100000
# Without the directory, zsh silently stops saving history.
[[ -d "${HISTFILE:h}" ]] || mkdir -p -- "${HISTFILE:h}"

setopt SHARE_HISTORY
# Timestamp + duration per entry, required by HIST_EXPIRE_DUPS_FIRST and
# `history -E`. Must be set BEFORE the first write: switching it on later
# leaves a mixed-format history.
setopt EXTENDED_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS

# --- Shell behaviour ---
setopt AUTOCD
setopt NOBEEP
setopt NUMERIC_GLOB_SORT
# bash enables this by default, zsh does not. Without it, a line pasted from a
# doc with a trailing `# comment` hands `#` and the words after it to the
# command as arguments.
setopt INTERACTIVE_COMMENTS

bindkey -v
# Not exported: ZLE-local. 100 ms, lower splits escape sequences over ssh.
KEYTIMEOUT=10

source "${ZDOTDIR}/zinit.zsh"

# --- Completion zstyle ---
zstyle ':completion::complete:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompcache"
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
# dircolors feeds LS_COLORS; macOS without coreutils just gets no colors.
if ((${+commands[dircolors]})); then
  eval "$(dircolors -b)"
elif ((${+commands[gdircolors]})); then
  eval "$(gdircolors -b)"
fi
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
# REQUIRED by fzf-tab: it must capture the unambiguous prefix instead of zsh
# opening its own menu.
zstyle ':completion:*' menu no

compdef eza=ls

if command -v eza >/dev/null 2>&1; then
  zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always --icons=auto $realpath 2>/dev/null'
  if command -v zoxide >/dev/null 2>&1; then
    zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza -1 --color=always --icons=auto $realpath 2>/dev/null'
  fi
else
  zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color=always $realpath 2>/dev/null'
fi

# `less` in a preview is a cat in disguise: fzf hands it a pipe. bat colours
# and numbers, and --line-range keeps a huge file from being read on every TAB.
if command -v bat >/dev/null 2>&1; then
  zstyle ':fzf-tab:complete:*:*' fzf-preview \
    'bat --color=always --style=numbers --line-range=:500 ${(Q)realpath} 2>/dev/null'
else
  zstyle ':fzf-tab:complete:*:*' fzf-preview 'cat ${(Q)realpath} 2>/dev/null'
fi

zstyle ':fzf-tab:*' fzf-min-height 20
zstyle ':fzf-tab:*' switch-group '<' '>'
zstyle ':fzf-tab:*' fzf-bindings 'tab:down'

# Only if zinit really loaded: otherwise every TAB on `zinit` autoloads a
# completion for a command that does not exist.
if ((${+functions[zinit]})); then
  autoload -Uz _zinit
  ((${+_comps})) && _comps[zinit]=_zinit
fi

# --- Modular Config ---
# Guarded: aliases.sh is a separate link, and a failed symlinks step must not
# break every zsh start.
_al="${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliases.sh"
[[ -r "$_al" ]] && source "$_al"
unset _al

source "${ZDOTDIR}/fzf.zsh" # fzf variables + widget (zsh)

# --- Tools init ---
# Guarded: a missing tool must never break the shell. The mise completion
# comes from the `usage` CLI, installed by ~/.config/mise/config.toml.
if command -v mise >/dev/null 2>&1; then
  # --shims, not the hook: same resolution as scripts get, and nothing here
  # uses a per-project [env].
  eval "$(mise activate zsh --shims)"
  # Cached once: regenerating at every startup costs a fork for the same
  # result. `./run upgrade` invalidates it.
  _mc="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/mise-completion.zsh"
  if [[ ! -r "$_mc" ]] && command -v usage >/dev/null 2>&1; then
    mkdir -p -- "${_mc:h}"
    mise completion zsh >"$_mc" 2>/dev/null || rm -f -- "$_mc"
  fi
  [[ -r "$_mc" ]] && source "$_mc"
  unset _mc
fi
# For the machine that HAS gpg: nothing here calls it, and the configs stay
# portable. `[ -t 0 ]` is load-bearing: without it `tty` prints "not a tty",
# and GPG_TTY holds THAT.
if command -v gpg >/dev/null 2>&1 && [ -t 0 ]; then
  GPG_TTY=$(tty)
  export GPG_TTY
fi

command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"
command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"

# AFTER `bindkey -v`: fzf rebinds Ctrl-R/Ctrl-T/Alt-C into the vi keymaps.
command -v fzf >/dev/null 2>&1 && eval "$(fzf --zsh)"

# --- PATH, last word ---
# zinit prepends its OWN polaris/bin from this file, i.e. after .zprofile, and
# `mise activate --shims` re-prepends the shims. Re-asserted here, last: the
# last word on PATH must not belong to a third-party clone tracking HEAD.
_zsh_build_path
# Defined in $ZDOTDIR/.zshenv, which .zprofile also needs, so it cannot be
# unset there. Here it can: nothing calls it afterwards. It still reaches
# non-interactive zsh, which reads .zshenv and stops -- that part is structural.
unset -f _zsh_build_path
