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
alias diff='diff --color=auto'
alias df='df -h'

# ------------------ Editor ------------------
alias v='nvim'

# ------------------ Git clone helpers ------------------
# ghc <repo> -> clone git@github.com:$GITUSER/<repo> into $GHREPOS/<repo>
ghc() { git clone "git@github.com:${GITUSER}/$1.git" "${GHREPOS}/$1" && cd "${GHREPOS}/$1"; }
# glc <repo> -> same for GitLab
glc() { git clone "git@gitlab.com:${GITUSER}/$1.git" "${GLREPOS}/$1" && cd "${GLREPOS}/$1"; }
