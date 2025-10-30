# ⚡ Quick Start

Guide ultra-rapide pour installer et configurer ce dotfiles.

---

## 📋 Prérequis (1 min)

<details>
<summary><b>macOS</b></summary>

```bash
# Installer Xcode Command Line Tools
xcode-select --install
```

</details>

<details>
<summary><b>Arch Linux</b></summary>

```bash
# Git et curl (normalement déjà installés)
sudo pacman -S git curl
```

</details>

---

## 🚀 Installation (3 min)

### 1. Cloner le dépôt

```bash
git clone https://github.com/your-username/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

### 2. Lancer l'installation

```bash
./bootstrap.sh
```

**Le script va automatiquement :**
- ✅ Détecter votre OS (macOS/Arch)
- ✅ Installer le gestionnaire de paquets (Homebrew si macOS)
- ✅ Installer tous les paquets nécessaires
- ✅ Créer les liens symboliques
- ✅ Configurer Zsh, Tmux, Git
- ✅ Installer les plugins

**Durée :** 3-10 minutes (selon connexion internet)

### 3. Recharger le shell

```bash
# Fermer et rouvrir le terminal, ou :
exec zsh
```

---

## ✅ Vérification (30 sec)

```bash
# Tester l'installation
./test.sh
```

**Sortie attendue :**
```
✅ All critical checks passed!
```

> **📦 Note Arch Linux :** Certains outils optionnels (`asdf`, `ghostty`, `zoxide`, `monaspace`) sont des packages AUR. Installez-les manuellement

---

## 🎯 Premiers pas

### Commandes essentielles

```bash
# Navigation
cd dots         # Jump intelligent (zoxide)

# Listing
ll              # Liste détaillée
la              # Tout afficher (cachés inclus)

# Git
gs              # git status
ga .            # git add .
gcm "message"   # git commit
gp              # git push

# Mise à jour
cd ~/.dotfiles
./update.sh
```

### Raccourcis importants

| Raccourci | Action |
|-----------|--------|
| `Ctrl+r` | Recherche historique (fzf) |
| `Ctrl+t` | Recherche fichier (fzf) |
| `Alt+c` | Recherche dossier (fzf) |

### Tmux (optionnel)

```bash
# Lancer tmux
tmux

# Préfixe : Ctrl+Space, puis :
# c     = Nouvelle fenêtre
# s     = Split horizontal
# v     = Split vertical
# d     = Détacher session
```

---

## 📚 Et après ?

### Personnalisation de base

```bash
# Éditer aliases
vim ~/.config/shell/aliases

# Ajouter variables d'environnement
vim ~/.config/shell/env

# Configurer Starship (prompt)
vim ~/.config/starship.toml
```

### Documentation complète

- **[Configuration](Configuration)** - Vue d'ensemble détaillée
- **[Cheatsheet](Cheatsheet)** - Référence rapide des commandes
- **[Customization Guide](Customization-Guide)** - Personnaliser en profondeur
- **[FAQ](FAQ)** - Questions fréquentes

---

## 🐛 Problème ?

### Zsh non défini par défaut

```bash
# macOS / Linux
chsh -s $(which zsh)
# Puis redémarrer terminal
```

### Variables non définies

```bash
# Recharger config
source ~/.zshrc
# ou
exec zsh
```

### Homebrew introuvable (macOS)

```bash
# Apple Silicon
eval "$(/opt/homebrew/bin/brew shellenv)"

# Intel
eval "$(/usr/local/bin/brew shellenv)"

# Puis relancer bootstrap
./bootstrap.sh
```

### Plus de help

- **[Installation complète](Installation)** - Guide détaillé pas à pas
- **[Troubleshooting](Troubleshooting)** - Solutions aux problèmes courants
- **[FAQ](FAQ)** - Questions fréquentes

---


💡 **Prochaine étape :** Explore le **[Cheatsheet](Cheatsheet)** pour les commandes les plus utiles.

