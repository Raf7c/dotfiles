#!/bin/sh
# ==========================================
# ~/asdf-install.sh
# ==========================================

set -eu

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
TOOL_VERSIONS_FILE="$SCRIPT_DIR/../.tool-versions"

if [ ! -f "$TOOL_VERSIONS_FILE" ]; then
    echo "Error: .tool-versions not found at $TOOL_VERSIONS_FILE"
    exit 1
fi

if ! command -v asdf >/dev/null 2>&1; then
    echo "Error: asdf is not installed or not in PATH"
    exit 1
fi

echo "Reading $TOOL_VERSIONS_FILE..."
echo ""

while read -r plugin version; do
    [ -z "$plugin" ] || [ -z "$version" ] && continue
    [ "$(echo "$plugin" | cut -c1)" = "#" ] && continue
    
    echo "Processing: $plugin $version"
    
    if ! asdf plugin list | grep -q "^${plugin}$"; then
        echo "  → Installing plugin: $plugin"
        if asdf plugin add "$plugin"; then
            echo "  ✓ Plugin $plugin installed"
        else
            echo "  ✗ Failed to install plugin $plugin"
            continue
        fi
    else
        echo "  ✓ Plugin $plugin already installed"
    fi
    
    if ! asdf list "$plugin" 2>/dev/null | grep -q "^[[:space:]]*${version}$"; then
        echo "  → Installing version: $plugin $version"
        if asdf install "$plugin" "$version"; then
            echo "  ✓ Version $version installed for $plugin"
        else
            echo "  ✗ Failed to install version $version for $plugin"
            continue
        fi
    else
        echo "  ✓ Version $version already installed for $plugin"
    fi
    
    echo ""
done < "$TOOL_VERSIONS_FILE"

echo "Installation complete!"
echo ""
echo "To set versions globally, run:"
echo "  asdf reshim"
