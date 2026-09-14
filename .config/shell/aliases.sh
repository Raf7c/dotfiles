#!/usr/bin/env sh
# bash/zsh aliases, POSIX syntax.
# Guarded: a missing tool must not break ls/cat on a fresh machine.

if command -v eza >/dev/null 2>&1; then
  # `--icons=auto` and not `--icons`: the flag takes an OPTIONAL value, so a
  # bare `--icons` swallows the next argument as that value. `ls file` then
  # dies on "invalid value 'file' for '--icons [<WHEN>]'". The `=` binds the
  # value to the flag and nothing can be eaten. Measured on eza 0.23.5.
  alias ls='eza --icons=auto'
  alias ll='eza -lh --icons=auto --git'
  alias la='eza -lah --icons=auto --git'
  alias lt='eza --tree --icons=auto'
else
  alias ll='ls -lh'
  alias la='ls -lah'
  # `ls` gets no alias here on purpose: without eza it IS the system ls, and
  # adding flags would mean picking between the BSD and GNU spellings.
  if command -v tree >/dev/null 2>&1; then
    alias lt='tree'
  fi
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

# ghc / glc <repo>: clone into $GHREPOS / $GLREPOS, then cd. TIDINESS only --
# git picks the identity from the remote URL, so a plain `git clone` anywhere
# works just as well (.config/git/README.md).
ghc() { git clone -- "git@github.com:${GITUSER}/$1.git" "${GHREPOS}/$1" && cd -- "${GHREPOS}/$1" || return 1; }
glc() { git clone -- "git@gitlab.com:${GLUSER}/$1.git" "${GLREPOS}/$1" && cd -- "${GLREPOS}/$1" || return 1; }
