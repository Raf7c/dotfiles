#!/usr/bin/env sh
# Common bash/zsh aliases (POSIX syntax).

# ------------------ Navigation ------------------
alias ls='eza --icons'
alias ll='eza -lh --icons --git'
alias la='eza -lah --icons --git'
alias tree='eza --tree --icons'

# ------------------ Tools ------------------
alias cat='bat'
alias rg='rg --color=auto'
alias diff='diff --color=auto'
alias df='df -h'

# ------------------ Editor ------------------
alias v='nvim'

# ------------------ Git clone helpers ------------------
# ghc <repo> -> clone git@github.com:$GITUSER/<repo> into $GHREPOS/<repo>
ghc() { git clone "git@github.com:${GITUSER}/$1.git" "${GHREPOS}/$1" && cd "${GHREPOS}/$1"; }
# glc <repo> -> same for GitLab
glc() { git clone "git@gitlab.com:${GITUSER}/$1.git" "${GLREPOS}/$1" && cd "${GLREPOS}/$1"; }
