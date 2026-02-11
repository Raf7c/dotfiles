#!/bin/bash
# asdf: install plugins and versions from .tool-versions

set -eu

DOTS_ROOT="${DOTS_ROOT:-$(cd "$(dirname "$0")/../.." && pwd)}"
[ -f "$DOTS_ROOT/.config/shell/env" ] && . "$DOTS_ROOT/.config/shell/env"

TOOL_VERSIONS="$DOTS_ROOT/.tool-versions"
if [ ! -f "$TOOL_VERSIONS" ]; then
  echo ".tool-versions file not found: $TOOL_VERSIONS" >&2
  exit 1
fi

if ! command -v asdf >/dev/null 2>&1; then
  echo "asdf is not installed or not in PATH" >&2
  exit 1
fi

# Ensure GNU Make signature key is available for GPG verification
if ! gpg --list-keys B2508A90102F8AE3B12A0090DEACCAAEDB78137A >/dev/null 2>&1; then
  gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys B2508A90102F8AE3B12A0090DEACCAAEDB78137A
fi

autres_plugins="$(asdf plugin list)"

while IFS=' ' read -r plugin version || [ -n "$plugin" ]; do
  [ -z "$plugin" ] && continue
  case "$plugin" in
    \#*) continue ;;
  esac
  [ -z "$version" ] && continue

  if ! printf '%s\n' "$autres_plugins" | grep -q "^${plugin}$"; then
    echo "asdf: installing plugin $plugin"
    if asdf plugin add "$plugin"; then
      autres_plugins="$(printf '%s\n%s' "$autres_plugins" "$plugin")"
    else
      echo "Cannot install plugin $plugin" >&2
      continue
    fi
  fi

  if ! asdf list "$plugin" 2>/dev/null | grep -q "^[[:space:]]*${version}$"; then
    echo "asdf: installing $plugin $version"
    if ! asdf install "$plugin" "$version"; then
      echo "Cannot install version $version" >&2
      continue
    fi
  fi
done < "$TOOL_VERSIONS"

echo "asdf: done."
