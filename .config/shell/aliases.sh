#!/usr/bin/env sh
# bash/zsh aliases, POSIX syntax.
# Guarded: a missing tool must not break ls/cat on a fresh machine.

if command -v eza >/dev/null 2>&1; then
  alias ls='eza --icons'
  alias ll='eza -lh --icons --git'
  alias la='eza -lah --icons --git'
  alias lt='eza --tree --icons'
else
  alias ll='ls -lh'
  alias la='ls -lah'
fi

command -v bat >/dev/null 2>&1 && alias cat='bat'
# BSD diff on macOS < 13 has no --color: a broken `diff` everywhere would be
# worse than a monochrome one.
if diff --color=auto /dev/null /dev/null >/dev/null 2>&1; then
  alias diff='diff --color=auto'
fi
alias df='df -h'

# One directory per line, in bash as in zsh.
alias path='printf "%s\n" "$PATH" | tr ":" "\n"'

alias v='nvim'

# Shell aliases, NOT git aliases: `gst` beats `git st`. The trade-off is that
# they live only in interactive shells; a script or an IDE sees plain git.
if command -v git >/dev/null 2>&1; then
  alias g='git'
  alias gst='git status'
  alias gd='git diff'
  alias gck='git checkout'
  alias gcm='git commit'
  alias gcma='git commit -a'
  alias gbr='git branch'
  alias gbra='git branch -a'
fi

# ghc / glc <repo>: clone $GITUSER/<repo> into $GHREPOS / $GLREPOS, then cd.
ghc() { git clone -- "git@github.com:${GITUSER}/$1.git" "${GHREPOS}/$1" && cd -- "${GHREPOS}/$1" || return 1; }
glc() { git clone -- "git@gitlab.com:${GITUSER}/$1.git" "${GLREPOS}/$1" && cd -- "${GLREPOS}/$1" || return 1; }
