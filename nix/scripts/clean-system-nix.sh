#!/bin/sh
# Script compatible avec sh et bash

# Désactiver l'arrêt sur erreur pour gérer les erreurs manuellement
set +e

echo "🧹 Début du nettoyage complet du système..."

# Fonction pour gérer les erreurs
handle_error() {
  echo "❌ Une erreur s'est produite : $1"
  echo "Redémarrage du daemon Nix..."
  sudo launchctl load /Library/LaunchDaemons/org.nixos.nix-daemon.plist > /dev/null 2>&1
  exit 1
}

# 1. Vérifier si le daemon Nix est en cours d'exécution
echo "🔍 Vérification du daemon Nix..."
if ! sudo launchctl list | grep -q org.nixos.nix-daemon; then
  echo "Le daemon Nix n'est pas en cours d'exécution. Démarrage..."
  sudo launchctl load /Library/LaunchDaemons/org.nixos.nix-daemon.plist
else
  echo "Le daemon Nix est en cours d'exécution."
fi

# 2. Nettoyer les profils et les générations sans arrêter le daemon
echo "🗑️ Nettoyage des profils et générations..."
rm -rf ~/.nix-profile > /dev/null 2>&1
rm -rf ~/.nix-defexpr > /dev/null 2>&1

# 3. Nettoyer le cache Nix
echo "🧼 Nettoyage du cache Nix..."
nix-collect-garbage -d
if [ $? -ne 0 ]; then
  handle_error "Échec de nix-collect-garbage"
fi

nix-store --gc
if [ $? -ne 0 ]; then
  handle_error "Échec de nix-store --gc"
fi

nix-store --optimise
if [ $? -ne 0 ]; then
  handle_error "Échec de nix-store --optimise"
fi

# 4. Détecter les configurations disponibles
echo "🔍 Détection des configurations disponibles..."
cd ~/.dotfiles/nix
if [ $? -ne 0 ]; then
  handle_error "Impossible d'accéder au répertoire ~/.dotfiles/nix"
fi

CONFIGS=$(grep -o '"raf-[^"]*"' flake.nix | tr -d '"')
CONFIG_COUNT=$(echo "$CONFIGS" | wc -l | xargs)

# 5. Proposer le choix de la configuration à reconstruire
if [ "$CONFIG_COUNT" -eq 0 ]; then
  echo "❌ Aucune configuration trouvée dans flake.nix"
  exit 1
elif [ "$CONFIG_COUNT" -eq 1 ]; then
  # S'il n'y a qu'une seule configuration, l'utiliser directement
  CONFIG=$(echo "$CONFIGS" | xargs)
  echo "Une seule configuration détectée : $CONFIG"
else
  # Sinon, proposer un choix
  echo "Plusieurs configurations détectées. Veuillez choisir :"
  
  # Afficher les options avec une boucle compatible sh
  i=1
  echo "$CONFIGS" | while read -r config; do
    echo "[$i] $config"
    i=$((i+1))
  done
  
  # Demander à l'utilisateur de choisir
  printf "Entrez le numéro de la configuration à reconstruire : "
  read CHOICE
  
  # Vérifier que le choix est valide
  if ! echo "$CHOICE" | grep -q '^[0-9]\+$' || [ "$CHOICE" -lt 1 ] || [ "$CHOICE" -gt "$CONFIG_COUNT" ]; then
    echo "❌ Choix invalide. Utilisation de la première configuration."
    CONFIG=$(echo "$CONFIGS" | head -n 1)
  else
    CONFIG=$(echo "$CONFIGS" | sed -n "${CHOICE}p")
  fi
fi

# 6. Reconstruire la configuration choisie
echo "🔨 Reconstruction de la configuration : $CONFIG..."
darwin-rebuild switch --flake .#$CONFIG
if [ $? -ne 0 ]; then
  handle_error "Échec de la reconstruction de la configuration"
fi

# 7. Vérifier les packages installés
echo "🔍 Vérification des packages installés..."
nix-env -q
if [ $? -ne 0 ]; then
  echo "Aucun package installé via nix-env"
fi

echo "Packages système :"
if ls -la /run/current-system/sw/bin/ | grep -E 'slack|tmux'; then
  echo "Attention : slack ou tmux sont encore installés"
else
  echo "Slack et tmux ont été correctement désinstallés!"
fi

echo "✅ Nettoyage terminé pour la configuration $CONFIG" 