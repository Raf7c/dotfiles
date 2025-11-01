# ⚙️ Configuration

Vue d'ensemble de la configuration des dotfiles.

## 📋 Table des matières

1. [Principes](#principes)
2. [Variables d'environnement](#variables-denvironnement)
3. [Chargement du shell](#chargement-du-shell)
4. [Structure](#structure)
5. [Shells](#shells)
6. [Configurations](#configurations)
7. [Thème](#thème)
8. [Liens symboliques](#liens-symboliques)
9. [Mise à jour](#mise-à-jour)

---

## 🏗️ Principes

### ✅ XDG Base Directory

Tous les fichiers suivent la [spécification XDG](https://specifications.freedesktop.org/basedir-spec/) :

```
~/.config/      → Configurations
~/.cache/       → Caches temporaires
~/.local/share/ → Données utilisateur
~/.local/state/ → Fichiers d'état
```

**Avantages :** Home propre · Sauvegarde facile · Standard cross-platform

### ✅ Modularité

```
.config/
├── git/       → Configuration Git
├── tmux/      → Configuration Tmux
├── shell/     → Variables + aliases
├── bat/       → Config bat
└── ghostty/   → Terminal
```

### ✅ Multi-plateforme

```
src/
├── lib/
│   ├── utils.sh              → Fonctions utilitaires (détection OS, print_*)
│   └── package_manager.sh    → Installation unifiée des paquets
├── macOS/
│   ├── homebrew.sh           → Installation/configuration Homebrew
│   ├── packages.sh           → Installation paquets macOS (Brewfile)
│   ├── osx.sh                → Préférences système
│   └── refresh-gcc-cache.sh  → Cache performance
├── arch/
│   ├── packages.sh           → Installation paquets Arch
│   └── arch.txt              → Paquets Arch Linux
└── common/
    ├── setup/
    │   └── link_global.sh    → Gestion des liens symboliques
    ├── shell/
    │   └── shell.sh          → Migration historique shell
    └── tools/
        ├── tmux.sh           → Installation TPM
        └── asdf.sh           → Installation plugins asdf
```

**Fichiers de packages :**
- **macOS :** `Brewfile` (à la racine) - Automatiquement maintenu avec `brew bundle dump`
- **Arch :** `src/arch/arch.txt`

**Détection automatique de l'OS :**
- `utils.sh` détecte l'OS via `uname -s` et `/etc/os-release`
- Variable `OS_TYPE` exportée : `macos`, `arch`, ou `linux`
- Scripts compatibles POSIX sh (pas bash-spécifique)

---

## 🌍 Variables d'environnement

**Fichier :** `.config/shell/env`

### Variables XDG

```bash
export XDG_CONFIG_HOME="$HOME/.config"      # Configurations
export XDG_CACHE_HOME="$HOME/.cache"        # Caches
export XDG_DATA_HOME="$HOME/.local/share"   # Données
export XDG_STATE_HOME="$HOME/.local/state"  # État
export DOTFILES="$HOME/.dotfiles"
```

### Variables principales

```bash
# Éditeur
export EDITOR="nvim"
export VISUAL="nvim"

# Pager
export PAGER="less"
export LESS="-R -F -X"

# OS
export OS_TYPE  # macos|arch|linux

# Historique
HISTFILE="$XDG_STATE_HOME/zsh/history"
HISTSIZE=10000
```

---

## 🔄 Chargement du shell

### Ordre Zsh

```
~/.zprofile  → Chargé au LOGIN (1 fois)
~/.zshrc     → Chargé à CHAQUE shell (tabs, panes)
```

### Structure

**~/.zprofile** → Source `.config/shell/env` (PATH, Homebrew, variables)  
**~/.zshrc** → Config Zsh + Zinit + Aliases + Starship  
**~/.config/shell/env** → Variables d'environnement  
**~/.config/shell/aliases** → Aliases globaux

---

## 📁 Structure

```
~/.dotfiles/
├── bootstrap.sh          # Installation principale
├── update.sh             # Mise à jour
├── test.sh               # Validation
│
├── src/              # Scripts par OS
│   ├── lib/              # Fonctions communes
│   ├── packages/         # Listes paquets (macos/arch)
│   ├── macOS/
│   └── arch/
│
├── .config/
│   ├── git/              # Config Git
│   ├── tmux/             # Config Tmux (modulaire)
│   ├── shell/            # env + aliases
│   ├── bat/
│   ├── ghostty/
│   └── starship.toml
│
├── zsh/
│   ├── .zprofile
│   ├── .zshrc
│   └── zinit.zsh
│
└── bash/
    ├── .bash_profile
    └── .bashrc
```

---

## 🐚 Shells

### Zsh (Principal)

**Features :** Zinit · Starship · Plugins async · Complétion · Performance < 200ms  
**Fichiers :** `.zprofile` · `.zshrc` · `zinit.zsh`  
**Détails :** [[Zsh-Configuration]]

### Bash (Secondaire)

**Features :** Variables env · Aliases · Historique XDG  
**Fichiers :** `.bash_profile` · `.bashrc`  
**Note :** Supporté pour compatibilité

---

## 🛠️ Configurations

### Git
**Emplacement :** `.config/git/config`  
**Features :** Aliases · Delta · Hooks  
**Détails :** [[Git-Configuration]]

### Tmux
**Emplacement :** `.config/tmux/`  
**Prefix :** `Ctrl+Space`  
**Features :** Plugins TPM · Thème Catppuccin · vim-tmux-navigator  
**Détails :** [[Tmux-Configuration]]

### Starship
**Emplacement :** `.config/starship.toml`  
**Features :** Prompt rapide et personnalisable

### Neovim
**Version :** 0.11.4 (via asdf)  
**Config :** `.config/nvim`

---

## 🎨 Thème

**Catppuccin** (Mocha/Latte)  
**Police :** Monaspace Xenon  
**Applications :** Ghostty · Tmux · Bat

---

## 🔗 Liens symboliques

Tout est lié depuis `~/.dotfiles/` vers `~/.config/` et `~/`  
**Avantage :** Modifications immédiatement actives

---

## 🔄 Mise à jour

```bash
cd ~/.dotfiles
./update.sh  # Met à jour : Homebrew, Zinit, Tmux, asdf
```

---

## 📚 Voir aussi

- [[Zsh-Configuration]] - Zsh + Zinit
- [[Tmux-Configuration]] - Tmux complet
- [[Git-Configuration]] - Git détaillé
- [[Performance-Optimizations]] - Optimisations

