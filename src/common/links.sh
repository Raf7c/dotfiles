#!/bin/sh
set -eu

DOTS_ROOT="${DOTS_ROOT:-$(CDPATH= cd "$(dirname "$0")/../.." && pwd)}"
. "$DOTS_ROOT/lib/helpers.sh"

link_file() {
  src="$1"
  dest="$2"

  if [ ! -e "$src" ]; then
    warn "$src does not exist, skipping"
    return 0
  fi

  ln -sfn "$src" "$dest"
  info "link: $dest -> $src"
}
mkdir -p "$HOME/.cache/zsh"
link_file "$DOTS_ROOT/.config/shell" "$HOME/.config/shell"
link_file "$DOTS_ROOT/.config/zsh" "$HOME/.config/zsh"
link_file "$DOTS_ROOT/.config/git" "$HOME/.config/git"
link_file "$DOTS_ROOT/.config/ghostty" "$HOME/.config/ghostty"
link_file "$DOTS_ROOT/.config/tmux" "$HOME/.config/tmux"
link_file "$DOTS_ROOT/.config/starship.toml" "$HOME/.config/starship.toml"
link_file "$DOTS_ROOT/.bashrc" "$HOME/.bashrc"
link_file "$DOTS_ROOT/.zshrc" "$HOME/.zshrc"
