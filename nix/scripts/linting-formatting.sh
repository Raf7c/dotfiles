#!/bin/bash

echo "=== Installing minimal formatting tools for Neovim ==="
echo "Note: These tools will also be installed by Mason in Neovim."

# Check for npm
if ! command -v npm &> /dev/null; then
    echo "❌ npm is required but not installed."
    exit 1
fi

echo "🔄 Installing main tools..."
npm install -g prettier

# Install Prettier plugins
echo "🔄 Installing selected Prettier plugins..."
npm install -g prettier-plugin-tailwindcss

echo ""
echo "✅ Installation verification:"
echo ""
for tool in prettier ; do
    if command -v $tool &> /dev/null; then
        echo "✓ $tool (global installation)"
    else
        echo "❌ $tool not found globally (but may be installed via Mason in Neovim)"
    fi
done

echo ""
echo "Installation complete. For additional tools, use Mason in Neovim (:Mason)."
echo "Configuration globale :"
echo "~/.prettierrc.json -> ~/.dotfiles/nix/home/common/core/formatting-config/.prettierrc.json"
echo ""
echo "Note: These tools will also be installed and managed by Mason in Neovim." 