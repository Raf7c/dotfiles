# 📦 Installation

Guide d'installation pour macOS.

---

## 🔧 Prérequis

### macOS
- **Version :** macOS 12.0+
- **Architecture :** Apple Silicon ou Intel

```bash
# Installer Xcode Command Line Tools
xcode-select --install
```

---

## 🚀 Installation

```bash
# 1. Cloner le dépôt
git clone --recurse-submodules https://github.com/Raf7c/dotfiles.git ~/.dotfiles

# 2. Lancer l'installation
cd ~/.dotfiles
./bootstrap.sh

# 3. Redémarrer le terminal
exec zsh
```

**Le script installe automatiquement :**
1. 🔗 Liens symboliques
2. 📦 Homebrew et paquets
3. 📚 Migration historique shell
4. 🔌 Tmux Plugin Manager
5. 🔧 Plugins asdf
6. ⚙️ Préférences macOS
7. 🔄 Cache GCC

---

## 🎯 Post-installation

### Installer les plugins Tmux

```bash
# Lancer Tmux
tmux

# Dans Tmux : Ctrl+Space puis I (majuscule)
```

### Configurer Git

```bash
git config --global user.name "Votre Nom"
git config --global user.email "votre.email@example.com"
```

---

## ✅ Vérification

```bash
# Vérifier les outils
brew --version
fzf --version
starship --version

# Vérifier les liens
ls -la ~/.config
ls -la ~/.zshrc

# Tester le temps de démarrage
time zsh -i -c exit
# → Devrait être < 0.2s
```

---

## 🔄 Mise à jour

Pour mettre à jour votre configuration et tous les paquets :

```bash
cd ~/.dotfiles
./update.sh
```

**Le script met à jour automatiquement :**
1. 📥 Dépôt Git (avec stash automatique si modifications)
2. 📦 Sous-modules (Neovim config)
3. 🍺 Homebrew et tous les paquets
4. 🔗 Liens symboliques
5. 🔧 asdf et ses plugins
6. 🔌 TPM et plugins Tmux
7. ⚡ Zinit et plugins Zsh
8. 🔄 Cache GCC
9. 🧹 Nettoyage des caches

**Durée :** 2-5 minutes

---

## 🔄 Réinstallation

Le script est **idempotent** - sûr de relancer :

```bash
cd ~/.dotfiles
./bootstrap.sh
```

---

## 🐛 Problèmes courants

### Homebrew introuvable

```bash
# Apple Silicon
eval "$(/opt/homebrew/bin/brew shellenv)"

# Intel
eval "$(/usr/local/bin/brew shellenv)"

# Puis relancer
./bootstrap.sh
```

### Permission denied

```bash
chmod +x bootstrap.sh
```

### Tmux plugins ne s'installent pas

```bash
rm -rf ~/.config/tmux/plugins/tpm
sh ~/.dotfiles/src/setup/tmux.sh

# Dans Tmux : Ctrl+Space + I
```

---

**Besoin d'aide ?** → Consultez [[FAQ]]
