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

# The formula ships `gcc-16` and never a plain `gcc`: Homebrew will not shadow
# Apple's. PERISHABLE: bump the number when brew moves to gcc-17. A keyboard
# convenience only -- `make` runs `cc` as a program and never sees an alias.
command -v gcc-16 >/dev/null 2>&1 && alias gcc='gcc-16'

# Shell aliases, NOT git aliases: `gs` beats `git st`. The trade-off is that
# they live only in interactive shells; a script or an IDE sees plain git.
# `gb*` and `gh*` are shared with zsh/fzf.zsh: check there before adding one.
if command -v git >/dev/null 2>&1; then
  alias g='git'
  alias ga='git add'
  alias ga.='git add .'
  alias gaa='git add --all'
  alias gs='git status'
  alias gd='git diff'
  alias gds='git diff --staged'
  alias gc='git commit'
  alias gck='git checkout'
  alias gb='git branch'
  alias gbd='git branch --delete'
  alias gbD='git branch -D'
  alias gpl='git pull'
  alias gp='git push'
  # `--oneline` IS `--pretty=oneline --abbrev-commit`, and `--decorate` is the
  # default on a terminal: both measured, both dropped.
  alias gl='git log --graph --oneline'
  alias gconf='git config --list --show-origin --show-scope'
fi

# ghc / glc <repo>: clone into $GHREPOS / $GLREPOS, then cd. TIDINESS only --
# git picks the identity from the remote URL, so a plain `git clone` anywhere
# works just as well (.config/git/README.md).
ghc() { git clone -- "git@github.com:${GITUSER}/$1.git" "${GHREPOS}/$1" && cd -- "${GHREPOS}/$1" || return 1; }
glc() { git clone -- "git@gitlab.com:${GLUSER}/$1.git" "${GLREPOS}/$1" && cd -- "${GLREPOS}/$1" || return 1; }
