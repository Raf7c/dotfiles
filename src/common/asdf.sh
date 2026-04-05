#!/bin/sh
# Sync asdf plugins and versions from .tool-versions.
set -eu

DOTS_ROOT="${DOTS_ROOT:-$(CDPATH= cd "$(dirname "$0")/../.." && pwd)}"
. "$DOTS_ROOT/lib/helpers.sh"

[ -f "$DOTS_ROOT/.config/shell/env" ] && . "$DOTS_ROOT/.config/shell/env"

TOOL_VERSIONS="$DOTS_ROOT/.tool-versions"
if [ ! -f "$TOOL_VERSIONS" ]; then
  fail ".tool-versions not found: $TOOL_VERSIONS"
fi

if ! command -v asdf >/dev/null 2>&1; then
  warn "asdf not in PATH, skipping (run dot again after a new shell if Homebrew just installed it)"
  exit 0
fi

installed_plugins="$(asdf plugin list)"

while IFS=' ' read -r plugin version || [ -n "$plugin" ]; do
  [ -z "$plugin" ] && continue
  case "$plugin" in
    \#*) continue ;;
  esac
  [ -z "$version" ] && continue

  if ! printf '%s\n' "$installed_plugins" | grep -q "^${plugin}$"; then
    info "asdf: adding plugin $plugin"
    if asdf plugin add "$plugin"; then
      installed_plugins="$(printf '%s\n%s' "$installed_plugins" "$plugin")"
    else
      warn "cannot add plugin $plugin"
      continue
    fi
  fi

  if ! asdf list "$plugin" 2>/dev/null | grep -q "^[[:space:]]*${version}$"; then
    info "asdf: installing $plugin $version"
    if ! asdf install "$plugin" "$version"; then
      warn "cannot install $plugin $version"
      continue
    fi
  fi
done < "$TOOL_VERSIONS"

info "asdf sync complete"
