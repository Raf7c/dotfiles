#!/usr/bin/env sh
# Common bash/zsh aliases (POSIX syntax).
# Guarded: a missing tool must NOT break ls/cat on a fresh machine.

# ------------------ Navigation ------------------
if command -v eza >/dev/null 2>&1; then
  alias ls='eza --icons'
  alias ll='eza -lh --icons --git'
  alias la='eza -lah --icons --git'
  alias lt='eza --tree --icons'
else
  alias ll='ls -lh'
  alias la='ls -lah'
fi

# ------------------ Tools ------------------
command -v bat >/dev/null 2>&1 && alias cat='bat'
# BSD diff on macOS < 13 has no --color: probe before aliasing, a broken
# `diff` everywhere is worse than a monochrome one.
if diff --color=auto /dev/null /dev/null >/dev/null 2>&1; then
  alias diff='diff --color=auto'
fi
alias df='df -h'

# Print $PATH, one directory per line (portable: works in bash & zsh)
alias path='printf "%s\n" "$PATH" | tr ":" "\n"'

# ------------------ Editor ------------------
alias v='nvim'

# ------------------ Git ------------------
# Shell aliases, NOT git aliases: `gst` beats `git st`. The trade-off is
# stated: these live only in interactive shells. A script, another shell
# or an IDE calling git sees plain git.
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

# ------------------ Git clone helpers ------------------
# ghc <repo> -> clone git@github.com:$GITUSER/<repo> into $GHREPOS/<repo>
ghc() { git clone -- "git@github.com:${GITUSER}/$1.git" "${GHREPOS}/$1" && cd -- "${GHREPOS}/$1" || return 1; }
# glc <repo> -> same for GitLab
glc() { git clone -- "git@gitlab.com:${GITUSER}/$1.git" "${GLREPOS}/$1" && cd -- "${GLREPOS}/$1" || return 1; }
