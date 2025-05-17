# dotfiles
[ 🇺🇸 ](../README.md)  [ 🇫🇷 ](./README_fr.md)

> [!NOTE] Ce document est écrit plus comme un rappel pour moi-même que pour vous.

## Table des matières

- [Points forts](#points-forts)
- [Feuille de route TODO](TODO.md)
- [Prérequis](#prérequis)
- [Structure](#structure)
- [Gestion des secrets](#gestion-des-secrets)
- [Outils et applications](#outils-et-applications)
- [Premiers pas](#premiers-pas)
- [Maintenance](#maintenance)

## Points forts

- **Configuration multi-machines**
  - Support MacStudio (dev-lab) et MacBookPro (dev-lab-bis)
  - Configurations dynamiques spécifiques à chaque machine
  - Configurations communes partagées

- **Environnement de développement**
  - Neovim avec configuration personnalisée
  - Intégration VSCode
  - Configuration Git
  - Gestionnaire de versions ASDF
  - Configuration shell personnalisée avec Starship

- **Gestion système**
  - Nix Flakes pour des builds reproductibles
  - Home Manager pour les configurations utilisateur
  - Intégration Homebrew pour les packages macOS
  - Nettoyage et optimisation automatiques

- **Interface utilisateur**
  - Terminal Kitty avec thème personnalisé
  - Thème Catppuccin Mocha
  - Police JetBrains Mono
  - Tailles de police adaptatives selon les appareils

## Prérequis

- **Configuration système**
  - macOS >= 15.2
  - Nix >= 2.25.4
  - Homebrew

- **Support matériel**
  - Support Apple Silicon (M1/M2)
  - Support configuration multi-écrans
  - Configurations adaptatives portable/bureau

## Structure

```
.
├── flake.nix                 # Point d'entrée principal
├── nix/
│   ├── darwin/              # Configurations spécifiques à macOS
│   │   ├── hosts/          # Configurations par machine
│   │   └── modules/        # Modules Darwin
│   ├── home/               # Configurations Home Manager
│   │   ├── programs/       # Configurations des programmes
│   │   └── profiles/       # Profils utilisateur
│   ├── common/             # Configurations partagées
│   │   ├── packages/       # Packages communs
│   │   └── fonts/         # Configurations des polices
│   └── lib/                # Fonctions de bibliothèque personnalisées
└── docs/                   # Documentation
```

## Outils et applications

### Outils de développement
- **Éditeurs**
  - Neovim
  - VSCode
  - Cursor

- **Contrôle de version**
  - Git
  - GitHub CLI
  - LazyGit

- **Terminal**
  - Kitty
  - Tmux
  - Prompt Starship

### Outils système
- **Gestion de packages**
  - Nix
  - Homebrew
  - ASDF

- **Surveillance système**
  - iStat Menus
  - CleanMyMac

### Productivité
- **Prise de notes**
  - Obsidian
  - Notion

- **Communication**
  - Slack
  - Discord

- **Design**
  - Figma

## Premiers pas

1. **Cloner le dépôt**
```shell
nix-shell -p git --run 'git clone https://github.com/Raf7c/dotfiles.git .dotfiles'
```

2. **Initialiser les sous-modules**
```shell
git submodule update --init --recursive
```

3. **Installer la configuration**
```shell
# Pour MacStudio
nix run nix-darwin --extra-experimental-features "nix-command flakes" -- switch --flake .#raf-devlab 

# Pour MacBookPro
nix run nix-darwin --extra-experimental-features "nix-command flakes" -- switch --flake .#raf-devlab-bis 
```

## Maintenance

### Commandes courantes
```shell
# Reconstruire la configuration système
darwin-rebuild --flake .#<host>

# Mettre à jour la configuration utilisateur
home-manager --flake .#<host>

# Construire des packages
nix build

# Nettoyer les anciennes générations
nix-collect-garbage -d
```

### Mises à jour
- `nix flake update` régulier pour mettre à jour les dépendances
- `home-manager switch` pour les mises à jour de configuration utilisateur
- `brew update` pour les packages Homebrew

## Contribution

N'hésitez pas à utiliser cette configuration comme référence ou point de départ pour votre propre configuration. Si vous trouvez des problèmes ou avez des suggestions, n'hésitez pas à ouvrir une issue ou à soumettre une pull request.

## Licence

Ce projet est sous licence MIT - voir le fichier [LICENSE](../LICENSE) pour plus de détails.
