#!/bin/sh
# ==========================================
# ~/asdf-install.sh
# Installing asdf plugins and versions
# ==========================================

set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

# Load utilities
. "$SCRIPT_DIR/../../lib/utils.sh"

echo "📦 Installing asdf plugins and versions..."

TOOL_VERSIONS_FILE="$SCRIPT_DIR/../../../.tool-versions"

# Verify .tool-versions exists
if [ ! -f "$TOOL_VERSIONS_FILE" ]; then
    print_error ".tool-versions not found at $TOOL_VERSIONS_FILE"
    exit 1
fi

# Verify asdf is available
if ! command -v asdf >/dev/null 2>&1; then
    print_error "asdf is not installed or not in PATH"
    exit 1
fi

echo "📖 Reading $TOOL_VERSIONS_FILE..."
echo ""

# Process each line in .tool-versions
# The 'while read || [ -n "$plugin" ]' ensures we read the last line even without trailing newline
while read -r plugin version || [ -n "$plugin" ]; do
    # Skip empty lines and comments
    [ -z "$plugin" ] && continue
    [ -z "$version" ] && continue
    case "$plugin" in
        \#*) continue ;;
    esac
    
    echo "🔧 Processing: $plugin $version"
    
    # Install plugin if not present
    if ! asdf plugin list | grep -q "^${plugin}$"; then
        echo "  ⬇️ Installing plugin: $plugin"
        if asdf plugin add "$plugin"; then
            print_success "  Plugin $plugin installed"
        else
            print_warning "  Failed to install plugin $plugin"
            continue
        fi
    else
        print_success "  Plugin $plugin already present"
    fi
    
    # Install version if not present
    if ! asdf list "$plugin" 2>/dev/null | grep -q "^[[:space:]]*${version}$"; then
        echo "  ⬇️ Installing version: $plugin $version"
        if asdf install "$plugin" "$version"; then
            print_success "  Version $version installed"
        else
            print_warning "  Failed to install version $version"
            continue
        fi
    else
        print_success "  Version $version already present"
    fi
    
    echo ""
done < "$TOOL_VERSIONS_FILE"

print_success "asdf installation completed!"
print_info "Run 'asdf reshim' to refresh shims if needed"
