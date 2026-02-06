#!/bin/bash
# asdf : installation des plugins et versions depuis .tool-versions

set -eu

DOTS_ROOT="${DOTS_ROOT:-$(cd "$(dirname "$0")/../.." && pwd)}"
[ -f "$DOTS_ROOT/.config/shell/env" ] && . "$DOTS_ROOT/.config/shell/env"

TOOL_VERSIONS="$DOTS_ROOT/.tool-versions"
if [ ! -f "$TOOL_VERSIONS" ]; then
  echo "Fichier .tool-versions introuvable : $TOOL_VERSIONS" >&2
  exit 1
fi

if ! command -v asdf >/dev/null 2>&1; then
  echo "asdf n'est pas installé ou absent du PATH" >&2
  exit 1
fi

autres_plugins="$(asdf plugin list)"

while IFS=' ' read -r plugin version || [ -n "$plugin" ]; do
  [ -z "$plugin" ] && continue
  case "$plugin" in
    \#*) continue ;;
  esac
  [ -z "$version" ] && continue

  if ! printf '%s\n' "$autres_plugins" | grep -q "^${plugin}$"; then
    echo "asdf: installation du plugin $plugin"
    if asdf plugin add "$plugin"; then
      autres_plugins="$(printf '%s\n%s' "$autres_plugins" "$plugin")"
    else
      echo "Impossible d'installer le plugin $plugin" >&2
      continue
    fi
  fi

  if ! asdf list "$plugin" 2>/dev/null | grep -q "^[[:space:]]*${version}$"; then
    echo "asdf: installation de $plugin $version"
    if ! asdf install "$plugin" "$version"; then
      echo "Impossible d'installer la version $version" >&2
      continue
    fi
  fi
done < "$TOOL_VERSIONS"

echo "asdf: terminé."
