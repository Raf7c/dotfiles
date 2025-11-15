#!/bin/sh

set -eu

DOTS_ROOT=${DOTS_ROOT:-$HOME/.dotfiles}
TOOL_VERSIONS_FILE="$DOTS_ROOT/.tool-versions"

[ ! -f "$TOOL_VERSIONS_FILE" ] && exit 1
command -v asdf >/dev/null 2>&1 || exit 1

autres_plugins="$(asdf plugin list)"

while IFS=' ' read -r plugin version || [ -n "$plugin" ]; do
    [ -z "$plugin" ] && continue
    case "$plugin" in
        \#*) continue ;;
    esac
    [ -z "$version" ] && continue

    if ! printf '%s\n' "$autres_plugins" | grep -q "^${plugin}$"; then
        asdf plugin add "$plugin" || continue
        autres_plugins="$(printf '%s\n%s' "$autres_plugins" "$plugin")"
    fi

    if ! asdf list "$plugin" 2>/dev/null | grep -q "^[[:space:]]*${version}$"; then
        asdf install "$plugin" "$version" || continue
    fi
done < "$TOOL_VERSIONS_FILE"
