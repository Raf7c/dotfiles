#!/usr/bin/env bash

# Ce script installe les extensions VSCode spécifiées

# Fonction pour afficher des messages colorés
print_message() {
  local color_green='\033[0;32m'
  local color_reset='\033[0m'
  echo -e "${color_green}[VSCode Extensions]${color_reset} $1"
}

# Vérifier si code est installé
if ! command -v code &> /dev/null; then
  echo "La commande 'code' n'est pas disponible. Assurez-vous que VSCode est installé et que la commande est dans votre PATH."
  exit 1
fi

# Liste des extensions à installer
extensions=(
  "PKief.material-icon-theme"          # Thème d'icônes Material Design
  "Catppuccin.catppuccin-vsc"          # Thème de couleurs Catppuccin
  "esbenp.prettier-vscode"             # Formateur de code Prettier
  "usernamehw.errorlens"               # Affichage amélioré des erreurs
  "ms-python.python"                   # Support Python
  "vscodevim.vim"                      # Émulation Vim pour VSCode
  "ryuta46.multi-command"              # Exécute plusieurs commandes en une seule
  "mhutchie.git-graph"                 # Affiche un graphique Git
  "eamodio.gitlens"                     # Améliore les fonctionnalités Git
  "tal7aouy.rainbow-bracket"           # Colore les parenthèses et accolades
  "oderwat.indent-rainbow"             # Colore les niveaux d'indentation
  "formulahendry.auto-rename-tag"      # Renomme automatiquement les balises HTML/XML jumelées
  "dbaeumer.vscode-eslint"             # Intègre ESLint pour la validation du code JavaScript/TypeScript
  "stylelint.vscode-stylelint"         # Intègre Stylelint pour la validation des fichiers CSS/SCSS/Less
)

# Installation des extensions
print_message "Installation des extensions VSCode..."

for extension in "${extensions[@]}"; do
  print_message "Installation de $extension..."
  code --install-extension "$extension" --force
done

print_message "Toutes les extensions ont été installées avec succès!" 