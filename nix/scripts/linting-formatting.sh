#!/bin/bash

echo "=== Installation des outils de formatage et linting officiels ==="

# Vérifier si pnpm est installé
if ! command -v pnpm &> /dev/null; then
    echo "❌ PNPM n'est pas installé sur votre système."
    echo "Veuillez d'abord installer PNPM avant d'exécuter ce script."
    echo "Vous pouvez installer PNPM avec : npm install -g pnpm"
    exit 1
fi

echo "✓ PNPM est bien installé, installation des outils..."

# Installer les outils principaux de formatage et linting
echo "🔄 Installation de prettier, eslint et stylelint..."
pnpm add -g prettier eslint stylelint

# Installer les plugins pour l'intégration entre ESLint et Prettier
echo "🔄 Installation des plugins d'intégration..."
pnpm add -g eslint-config-prettier stylelint-config-prettier

# Installer les plugins Prettier officiels et activement maintenus
echo "🔄 Installation des plugins Prettier..."
pnpm add -g prettier-plugin-tailwindcss

# Installer les plugins ESLint officiels et activement maintenus
echo "🔄 Installation des plugins ESLint..."
pnpm add -g @typescript-eslint/parser @typescript-eslint/eslint-plugin
pnpm add -g eslint-plugin-vue
pnpm add -g eslint-plugin-json-schema-validator
pnpm add -g eslint-plugin-html
pnpm add -g eslint-plugin-markdown
pnpm add -g eslint-plugin-yml

# Installer les plugins Stylelint officiels et activement maintenus
echo "🔄 Installation des plugins Stylelint..."
pnpm add -g stylelint-config-standard
pnpm add -g stylelint-config-recommended
pnpm add -g stylelint-config-tailwindcss
pnpm add -g stylelint-scss
pnpm add -g stylelint-order
pnpm add -g postcss-scss
pnpm add -g postcss-less

# Vérification de l'installation
echo ""
echo "✅ Vérification de l'installation :"
echo ""
for tool in prettier eslint stylelint; do
    if command -v $tool &> /dev/null; then
        echo "✓ $tool (installation globale)"
    else
        echo "❌ $tool n'a pas été trouvé globalement"
    fi
done

echo ""
echo "Installation terminée."
echo ""
echo "Note : Ces outils peuvent également être installés et gérés par Mason dans Neovim."