#!/bin/sh

set -eu

mkdir -p "$HOME/.cache"

if command -v brew >/dev/null 2>&1 && brew list gcc >/dev/null 2>&1; then
    GCC_PREFIX=$(brew --prefix gcc 2>/dev/null || echo "")

    if [ -n "$GCC_PREFIX" ] && [ -d "$GCC_PREFIX/bin" ]; then
        GCC_VERSION=$(brew list --versions gcc 2>/dev/null | awk '{print $NF}' | grep -oE '^[0-9]+' || echo "")

        if [ -z "$GCC_VERSION" ]; then
            GCC_VERSION=$(ls "$GCC_PREFIX/bin"/gcc-* 2>/dev/null | head -n1 | grep -oE '[0-9]+$' || echo "")
        fi

        if [ -n "$GCC_VERSION" ] && [ -f "$GCC_PREFIX/bin/gcc-$GCC_VERSION" ]; then
            cat > "$HOME/.cache/gcc_aliases" <<EOF
# Auto-generated GCC aliases
alias gcc="$GCC_PREFIX/bin/gcc-$GCC_VERSION"
alias g++="$GCC_PREFIX/bin/g++-$GCC_VERSION"
EOF
        fi
    fi
else
    rm -f "$HOME/.cache/gcc_aliases"
fi