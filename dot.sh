#!/bin/sh
# dot — POSIX dotfiles sync (one command: run this script).
set -eu

DOTS_ROOT="$(CDPATH= cd "$(dirname "$0")" && pwd)"
export DOTS_ROOT

. "$DOTS_ROOT/lib/helpers.sh"

if [ "$#" -gt 0 ]; then
  fail "unexpected arguments"
fi

. "$DOTS_ROOT/lib/run.sh"
