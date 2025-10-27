#!/bin/sh
# ==========================================
# ~/install/macOS/refresh-gcc-cache.sh
# ==========================================

set -eu

echo "🔄 Refreshing GCC cache..."

# Create cache directory
mkdir -p "$HOME/.cache"

if command -v brew >/dev/null 2>&1 && brew list gcc &>/dev/null; then
    # GCC is installed, find version
    GCC_PREFIX="/opt/homebrew/opt/gcc"
    
    if [ -d "$GCC_PREFIX/bin" ]; then
        # Find the GCC version number
        GCC_VERSION=$(ls "$GCC_PREFIX/bin"/gcc-* 2>/dev/null | head -n1 | grep -oE '[0-9]+$')
        
        if [ -n "$GCC_VERSION" ]; then
            # Write aliases to cache file
            cat > "$HOME/.cache/gcc_aliases" <<EOF
# Auto-generated GCC aliases
# Regenerate with: sh ~/refresh-gcc-cache.sh
alias gcc="$GCC_PREFIX/bin/gcc-$GCC_VERSION"
alias g++="$GCC_PREFIX/bin/g++-$GCC_VERSION"
EOF
            echo "✅ GCC cache created: gcc-$GCC_VERSION"
            echo "📍 Location: $HOME/.cache/gcc_aliases"
        else
            echo "⚠️  Could not detect GCC version"
        fi
    else
        echo "⚠️  GCC directory not found: $GCC_PREFIX/bin"
    fi
else
    echo "ℹ️  GCC is not installed via Homebrew"
    # Remove cache if it exists
    rm -f "$HOME/.cache/gcc_aliases"
fi