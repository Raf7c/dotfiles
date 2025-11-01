#!/bin/sh
# ==========================================
# ~/.dotfiles/src/macOS/refresh-gcc-cache.sh
# Generate GCC aliases cache for Homebrew
# ==========================================

set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

# Load utilities
. "$SCRIPT_DIR/../lib/utils.sh"

echo "🔄 Refreshing GCC cache..."

# Create cache directory
mkdir -p "$HOME/.cache"

if command -v brew >/dev/null 2>&1 && brew list gcc &>/dev/null; then
    # GCC is installed, find prefix dynamically (works on both Apple Silicon and Intel)
    GCC_PREFIX=$(brew --prefix gcc 2>/dev/null || echo "")
    
    if [ -n "$GCC_PREFIX" ] && [ -d "$GCC_PREFIX/bin" ]; then
        # Find the GCC version number using brew list for better reliability
        GCC_VERSION=$(brew list --versions gcc 2>/dev/null | awk '{print $NF}' | grep -oE '^[0-9]+' || echo "")
        
        # Fallback: try to detect from filesystem
        if [ -z "$GCC_VERSION" ]; then
            GCC_VERSION=$(ls "$GCC_PREFIX/bin"/gcc-* 2>/dev/null | head -n1 | grep -oE '[0-9]+$' || echo "")
        fi
        
        if [ -n "$GCC_VERSION" ] && [ -f "$GCC_PREFIX/bin/gcc-$GCC_VERSION" ]; then
            # Write aliases to cache file
            cat > "$HOME/.cache/gcc_aliases" <<EOF
# Auto-generated GCC aliases
# Regenerate with: sh ~/.dotfiles/src/macOS/refresh-gcc-cache.sh
alias gcc="$GCC_PREFIX/bin/gcc-$GCC_VERSION"
alias g++="$GCC_PREFIX/bin/g++-$GCC_VERSION"
EOF
            print_success "GCC cache created: gcc-$GCC_VERSION"
            echo "📍 Location: $HOME/.cache/gcc_aliases"
        else
            print_warning "Could not detect GCC version or binary not found"
        fi
    else
        print_warning "GCC directory not found: ${GCC_PREFIX:-unknown}/bin"
    fi
else
    print_info "GCC is not installed via Homebrew"
    # Remove cache if it exists
    rm -f "$HOME/.cache/gcc_aliases"
fi