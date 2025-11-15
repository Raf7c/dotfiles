#!/bin/sh

set -eu

if command -v brew >/dev/null 2>&1; then
    :
elif [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv)"
else
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    if [ -x /opt/homebrew/bin/brew ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [ -x /usr/local/bin/brew ]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
fi

DOTS_ROOT=${DOTS_ROOT:-$HOME/.dotfiles}
BREWFILE="$DOTS_ROOT/Brewfile"

[ -f "$BREWFILE" ] && brew bundle --file="$BREWFILE"

