#!/bin/bash

echo "=== Installing linting and formatting tools for Neovim ==="

# Check for npm
if ! command -v npm &> /dev/null; then
    echo "❌ npm is required but not installed."
    exit 1
fi

echo "🔄 Installing main tools..."
npm install -g eslint eslint_d prettier

echo "🔄 Installing prettierd..."
npm install -g @fsouza/prettierd

# Install eslint-config-prettier for ESLint/Prettier integration
echo "🔄 Installing eslint-config-prettier..."
npm install -g eslint-config-prettier

# Install Prettier plugins
echo "🔄 Installing Prettier plugins..."
npm install -g prettier-plugin-tailwindcss @trivago/prettier-plugin-sort-imports

echo ""
echo "✅ Installation verification:"
echo ""
for tool in eslint eslint_d prettier; do
    if command -v $tool &> /dev/null; then
        echo "✓ $tool"
    else
        echo "❌ $tool not found"
    fi
done

# Special check for prettierd
if command -v prettierd &> /dev/null; then
    echo "✓ prettierd"
else
    echo "❌ prettierd not found (install via Mason if needed)"
fi

echo ""
echo "Installation complete. If any tools are missing, use Mason in Neovim (:Mason)."
echo "For documentation: eslint.org | prettier.io | github.com/fsouza/prettierd"
echo "Global configuration files are now linked to your home directory:"
echo "~/.prettierrc.json -> ~/.dotfiles/nix/home/common/core/formatting-config/.prettierrc.json"
echo "~/.eslintrc.json -> ~/.dotfiles/nix/home/common/core/linting-config/.eslintrc.json" 