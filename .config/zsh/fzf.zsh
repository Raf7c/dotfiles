#!/usr/bin/env zsh

# fzf integration. Sourced unconditionally by .zshrc, so EVERYTHING here is
# guarded: on a machine without fzf this file must define nothing and print
# nothing. (( ${+commands[x]} )) is the native zsh test, no fork.
((${+commands[fzf]})) || return 0

# ------------------ Source command ------------------
# fd when available, otherwise a real find fallback. -path … -prune is
# portable on GNU and BSD find (macOS), unlike -printf.
if ((${+commands[fd]})); then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --strip-cwd-prefix'
  # Same source, without the hidden files (Ctrl+F widget below).
  _FZF_NO_HIDDEN_COMMAND='fd --type f --strip-cwd-prefix'
else
  export FZF_DEFAULT_COMMAND="find . -path '*/.git' -prune -o -type f -print"
  _FZF_NO_HIDDEN_COMMAND="find . -path '*/.*' -prune -o -type f -print"
fi
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

export FZF_DEFAULT_OPTS='
--height=60%
--layout=reverse
--border=rounded
--prompt=" "
--pointer=" "
--preview-window=right:65%:wrap:border-left'

# Reusable preview command (shell variable: no need to export it).
# bat is optional too — fall back to head, which is always there.
if ((${+commands[bat]})); then
  _FZF_PREVIEW_CMD='bat --color=always --style=plain,numbers --line-range=:500 {}'
else
  _FZF_PREVIEW_CMD='head -n 500 -- {}'
fi
export FZF_CTRL_T_OPTS="--preview '$_FZF_PREVIEW_CMD'"

# ------------------ Ctrl+F: files, hidden ones excluded ------------------
_fzf_file_no_hidden() {
  local result
  result=$(eval "$_FZF_NO_HIDDEN_COMMAND" | fzf --preview "$_FZF_PREVIEW_CMD") &&
    LBUFFER+="$result"
  zle reset-prompt
}
zle -N _fzf_file_no_hidden
# Binding declared here, next to the widget it uses, so it can never
# outlive the widget.
bindkey '^F' _fzf_file_no_hidden

# ------------------ fzf-git.sh: plain-command aliases ------------------
# The plugin binds CTRL-G CTRL-{F,B,T,R,H,S,L,W,E}; these call the very
# same functions as commands. Difference worth knowing: the binding
# INSERTS the selection on the command line, the alias PRINTS it — so
# `git switch $(gfb)` works. gf* namespace on purpose: it can never
# collide with the g* git aliases of shell/aliases.sh.
alias gff='_fzf_git_files'
alias gfb='_fzf_git_branches'
alias gft='_fzf_git_tags'
alias gfr='_fzf_git_remotes'
alias gfh='_fzf_git_hashes'
alias gfs='_fzf_git_stashes'
alias gfl='_fzf_git_lreflogs'
alias gfw='_fzf_git_worktrees'
alias gfe='_fzf_git_each_ref'
alias gfk='_fzf_git_list_bindings'
