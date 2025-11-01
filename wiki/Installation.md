# 📦 Installation

Guide d'installation complet pour configurer l'environnement de développement macOS.

## 📋 Table des matières

1. [Prérequis](#prérequis)
2. [Installation rapide](#installation-rapide)
3. [Installation détaillée](#installation-détaillée)
4. [Post-installation](#post-installation)
5. [Vérification](#vérification)

---

## 🔧 Prérequis

### 🖥️ Systèmes supportés

Le script `bootstrap.sh` détecte automatiquement le système d'exploitation mais n'installe que sur macOS.

#### macOS (Supporté)
- **Version :** macOS 12.0+ (Monterey ou supérieur)
- **Architecture :** Apple Silicon (M1/M2/M3/M4) ou Intel
- **Espace disque :** ~5 GB

**Installation des outils requis :**
```bash
# Installer Xcode Command Line Tools
xcode-select --install
```

Cela installe automatiquement : `git`, `curl`, compilateurs de base

**Vérification :**
```bash
git --version && curl --version && sw_vers
```

#### Autres systèmes

⚠️ **Note :** Le script détecte automatiquement le système d'exploitation mais n'installe que sur macOS. Sur Linux ou autres systèmes, l'installation s'arrêtera avec un message d'erreur indiquant que seul macOS est supporté.

---

## 🚀 Installation rapide

Pour une installation standard en 3 commandes :

```bash
# 1. Cloner le dépôt
git clone https://github.com/votre-username/.dotfiles.git ~/.dotfiles

# 2. Aller dans le dossier
cd ~/.dotfiles

# 3. Lancer l'installation
./bootstrap.sh
```

**Durée estimée :** 3-10 minutes

Le script affichera sa progression et sauvegardera tous les logs dans `~/.dotfiles/install.log`.

---

## 📖 Installation détaillée

### Étape 1 : Cloner le dépôt

```bash
git clone https://github.com/votre-username/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

**Emplacement :** `~/.dotfiles/` (recommandé)

### Étape 2 : Comprendre bootstrap.sh

Le script `bootstrap.sh` effectue les actions suivantes dans l'ordre :

```
1. 🔍 Vérification système
   └─ Détecte l'OS (macOS uniquement supporté)
   └─ Vérifie git + curl

2. 🔗 Liens symboliques
   └─ Crée les liens ~/.config, ~/.zshrc, etc.

3. 📦 Gestionnaire de paquets (macOS uniquement)
   └─ Installe/configure Homebrew
   └─ Installe les paquets depuis Brewfile

4. 📚 Migration shell
   └─ Déplace l'historique vers XDG directories

5. 📦 Tmux Plugin Manager
   └─ Clone TPM pour les plugins Tmux (si tmux installé)

6. 🔧 Plugins asdf
   └─ Installe versions depuis .tool-versions (si asdf installé)

7. ⚙️ Configuration macOS
   └─ Cache GCC + Préférences système (Dock, Finder)
```

### Étape 3 : Lancer l'installation

```bash
./bootstrap.sh
```

**Sortie attendue :**
```
=========================================
🚀 Dotfiles Installation
📝 Logging to: /Users/raf/.dotfiles/install.log
📅 Started at: 2025-01-28 10:00:00
=========================================

✅ OS detected: macos (macos)
✅ git: /usr/bin/git
✅ curl: /usr/bin/curl
✅ All requirements met

▶️  Creating symbolic links
✅ Creating symbolic links completed

▶️  Installing packages
🍺 Installing Homebrew...
[... installation de tous les packages ...]
✅ Package installation completed

[... autres étapes ...]

=========================================
🎉 Configuration completed!
⏱️  Total time: 5m 23s
📝 Full log: /Users/raf/.dotfiles/install.log
💡 Some changes may require a logout/restart.
=========================================
```

### Étape 4 : Consulter le log (optionnel)

```bash
# Voir le log complet
cat ~/.dotfiles/install.log

# Voir seulement les erreurs
grep "❌" ~/.dotfiles/install.log
```

---

## 🎯 Post-installation

### 1. Redémarrer le terminal

```bash
# Option 1 : Recharger le shell
exec zsh

# Option 2 : Fermer et rouvrir le terminal
```

### 2. Installer les plugins Tmux

```bash
# Lancer Tmux
tmux

# Dans Tmux, presser : Ctrl+Space puis I (majuscule)
# Attendre l'installation des plugins
```

**Plugins installés :**
- vim-tmux-navigator
- tmux-resurrect
- tmux-continuum

### 3. Vérifier Zinit

```bash
# Au premier démarrage de Zsh, Zinit se compile automatiquement
# Vous devriez voir :
# "Zinit: Compiling..."
# "Zinit: Done!"

# Vérifier les plugins installés
zinit list
```

### 4. Configurer Git (si non fait)

```bash
git config --global user.name "Votre Nom"
git config --global user.email "votre.email@example.com"
```

### 5. Installer les versions de langages (asdf)

```bash
# Vérifier asdf
asdf --version

# Neovim est déjà installé via .tool-versions
nvim --version
# → NVIM v0.11.4

# Ajouter d'autres langages (optionnel)
asdf plugin add nodejs
asdf install nodejs latest
asdf global nodejs latest
```

---

## ✅ Vérification

### Test complet de l'installation

Un script de test automatique est disponible :

```bash
cd ~/.dotfiles
./test.sh
```

### Test manuel

```bash
# 1. Vérifier le gestionnaire de paquets
# Vérifier Homebrew
brew --version && brew list

# 2. Vérifier les packages CLI
fzf --version
rg --version
fd --version
eza --version
zoxide --version
starship --version
bat --version

# 3. Vérifier asdf
asdf --version
asdf plugin list
asdf list

# 4. Vérifier les liens symboliques
ls -la ~/.config
ls -la ~/.zshrc
ls -la ~/.vimrc

# 5. Vérifier Zinit
zinit list

# 6. Vérifier le shell
echo $SHELL
# → /bin/zsh

# 7. Vérifier les variables XDG
echo $XDG_CONFIG_HOME
# → /Users/votre-user/.config

echo $XDG_DATA_HOME
# → /Users/votre-user/.local/share

# 8. Tester les aliases
ll
# → Doit afficher le contenu avec eza

cd /tmp
# → Doit utiliser zoxide (cd est aliasé à z)

# 9. Vérifier le cache GCC (si GCC installé)
cat ~/.cache/gcc_aliases
```

### Benchmarker le temps de démarrage

```bash
# Test du temps de démarrage du shell
time zsh -i -c exit
# → Devrait être < 0.2s (200ms)
```

---

## 🔄 Réinstallation

Si vous devez réinstaller :

```bash
cd ~/.dotfiles
./bootstrap.sh
```

**Note :** `bootstrap.sh` est **idempotent** - sûr de relancer plusieurs fois.

**Ce qui se passe lors d'une réinstallation :**
- ✅ Les liens symboliques sont recréés (écrasent les anciens)
- ✅ Le gestionnaire de paquets skip les paquets déjà installés
- ✅ L'historique shell n'est pas écrasé
- ✅ TPM skip si déjà installé
- ✅ asdf skip les plugins déjà présents

---

## 🎯 Cas d'usage spécifiques

### Cas 1 : J'ai déjà Homebrew installé

**Situation :** Homebrew est déjà installé, vous ne voulez pas le réinstaller.

**Solution :** Le script détecte automatiquement Homebrew et skip l'installation.

```bash
# Lancer l'installation normalement
./bootstrap.sh

# Le script va :
# 1. Détecter Homebrew existant
# 2. Skip l'installation
# 3. Continuer avec les paquets
```

**Sortie attendue :**
```
▶️  Configuring Homebrew
🍺 Configuring Homebrew...
✅ Homebrew already installed: Homebrew 4.2.0
✅ Configuring Homebrew completed
```

**Vérification :**
```bash
# Vérifier la version Homebrew
brew --version

# Lister les paquets installés
brew list
```

**Si vous voulez une installation propre :**
```bash
# Option 1: Garder Homebrew mais réinstaller paquets
brew list | xargs brew reinstall

# Option 2: Désinstaller et réinstaller Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/src/HEAD/uninstall.sh)"
# Puis relancer bootstrap.sh
```

---

### Cas 2 : J'ai déjà tmux configuré

**Situation :** Vous avez déjà une configuration tmux dans `~/.tmux.conf` que vous voulez conserver.

**Option A : Backup et utiliser cette configuration**

```bash
# 1. Backup votre config actuelle
cp ~/.tmux.conf ~/.tmux.conf.backup
cp -r ~/.tmux ~/.tmux.backup 2>/dev/null || true

# 2. Lancer l'installation (remplace votre config)
./bootstrap.sh

# 3. Si vous voulez restaurer certains éléments :
# Éditer ~/.config/tmux/tmux.conf
nvim ~/.config/tmux/tmux.conf

# Ajouter vos configurations custom
```

**Option B : Garder votre config et skip tmux**

```bash
# 1. Cloner les dotfiles
git clone ... ~/.dotfiles
cd ~/.dotfiles

# 2. Éditer bootstrap.sh pour skip tmux
nvim bootstrap.sh

# Commenter la section tmux :
# run_step "Installing Tmux plugins" \
#     "$SCRIPT_DIR/src/tmux-tmp.sh" \
#     "optional"

# 3. Lancer installation
./bootstrap.sh
```

**Option C : Fusionner les configurations**

```bash
# 1. Installer les dotfiles
./bootstrap.sh

# 2. Copier vos configurations custom
cat ~/.tmux.conf.backup >> ~/.config/tmux/tmux.conf

# 3. Ou créer un fichier override
cat ~/.tmux.conf.backup > ~/.config/tmux/local.conf

# 4. Dans ~/.config/tmux/tmux.conf, ajouter à la fin :
echo 'source-file ~/.config/tmux/local.conf' >> ~/.config/tmux/tmux.conf
```

**Comparer les configurations :**

```bash
# Voir différences
diff ~/.tmux.conf.backup ~/.config/tmux/tmux.conf

# Avec coloration
git diff --no-index ~/.tmux.conf.backup ~/.config/tmux/tmux.conf
```

---

### Cas 3 : Installation partielle (seulement Zsh)

**Situation :** Vous voulez seulement la configuration Zsh, pas Homebrew ni les autres outils.

**Méthode 1 : Installation manuelle**

```bash
# 1. Cloner le repo
git clone https://github.com/votre-username/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# 2. Créer seulement les liens symboliques Zsh
ln -sf ~/.dotfiles/zsh/.zshrc ~/.zshrc
ln -sf ~/.dotfiles/zsh/.zprofile ~/.zprofile
ln -sf ~/.dotfiles/.config/shell ~/.config/shell
ln -sf ~/.dotfiles/.config/zsh ~/.config/zsh

# 3. Installer Zinit manuellement
bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"

# 4. Recharger le shell
exec zsh
```

**Méthode 2 : Script personnalisé**

```bash
# 1. Créer un script custom
cat > ~/.dotfiles/install-zsh-only.sh << 'EOF'
#!/bin/sh
set -eu

DOTFILES="$HOME/.dotfiles"

echo "📦 Installing Zsh configuration only..."

# Liens symboliques
echo "🔗 Creating symbolic links..."
ln -sf "$DOTFILES/zsh/.zshrc" "$HOME/.zshrc"
ln -sf "$DOTFILES/zsh/.zprofile" "$HOME/.zprofile"
mkdir -p "$HOME/.config"
ln -sf "$DOTFILES/.config/shell" "$HOME/.config/shell"
ln -sf "$DOTFILES/.config/zsh" "$HOME/.config/zsh"
echo "✅ Links created"

# Installer Zinit
if [ ! -d "$HOME/.local/share/zinit" ]; then
    echo "📦 Installing Zinit..."
    git clone https://github.com/zdharma-continuum/zinit.git \
        "$HOME/.local/share/zinit/zinit.git"
    echo "✅ Zinit installed"
fi

# Installer Starship
if ! command -v starship >/dev/null 2>&1; then
    echo "✨ Installing Starship..."
    curl -sS https://starship.rs/install.sh | sh
    echo "✅ Starship installed"
fi

echo "🎉 Zsh configuration installed!"
echo "💡 Run: exec zsh"
EOF

chmod +x ~/.dotfiles/install-zsh-only.sh

# 2. Exécuter
~/.dotfiles/install-zsh-only.sh

# 3. Recharger
exec zsh
```

**Prérequis minimaux pour Zsh uniquement :**

```bash
# Installer seulement ce qui est nécessaire

# macOS
brew install starship zoxide fzf bat eza ripgrep fd
```

**Vérifier l'installation :**

```bash
# Tester le shell
time zsh -i -c exit
# → Devrait être < 0.2s

# Vérifier les plugins
zinit list

# Vérifier Starship
starship --version
```

**Ajouter progressivement d'autres outils :**

```bash
# 1. Ajouter Git config
ln -sf ~/.dotfiles/.config/git ~/.config/git

# 2. Ajouter Tmux config
ln -sf ~/.dotfiles/.config/tmux ~/.config/tmux

# 3. Installer TPM
sh ~/.dotfiles/src/tmux-tmp.sh

# 4. Installer asdf
sh ~/.dotfiles/src/asdf-install.sh
```

---

### Cas 4 : Installation sur une machine macOS de production

**Situation :** Serveur macOS de production, vous voulez seulement les configs essentielles.

**Approche minimaliste :**

```bash
# 1. Installer seulement les essentiels
git clone https://github.com/votre-username/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# 2. Créer script minimal
cat > install-minimal.sh << 'EOF'
#!/bin/sh
set -eu

# Liens essentiels seulement
ln -sf ~/.dotfiles/zsh/.zshrc ~/.zshrc
ln -sf ~/.dotfiles/.config/git ~/.config/git
ln -sf ~/.dotfiles/.config/shell ~/.config/shell

# Variables d'environnement
mkdir -p ~/.config
cp ~/.dotfiles/.config/shell/env ~/.config/shell/env

echo "✅ Minimal config installed"
EOF

chmod +x install-minimal.sh
./install-minimal.sh

# 3. Pas de plugins, pas de Starship
# Utiliser prompt simple dans .zshrc
```

**Configuration serveur (sans GUI, sans extras) :**

```bash
# Ne pas installer :
# - Applications GUI (ghostty, cursor, etc.)
# - Outils graphiques
# - Thèmes complexes

# Installer seulement :
# - Git config
# - Shell aliases utiles
# - Variables d'environnement
# - Tmux pour sessions multiples
```

---

### Cas 5 : Migration progressive

**Situation :** Vous voulez tester avant de tout migrer.

**Étape 1 : Test sans modification**

```bash
# Cloner dans un dossier temporaire
git clone https://github.com/votre-username/.dotfiles.git ~/dotfiles-test

# Tester les configs
zsh -c 'source ~/dotfiles-test/zsh/.zshrc'

# Si ça marche, continuer
```

**Étape 2 : Installation parallèle**

```bash
# Garder votre .zshrc actuel
mv ~/.zshrc ~/.zshrc.old

# Lien vers nouvelle config
ln -sf ~/dotfiles-test/zsh/.zshrc ~/.zshrc

# Tester
exec zsh

# Si problème, revenir
rm ~/.zshrc
mv ~/.zshrc.old ~/.zshrc
exec zsh
```

**Étape 3 : Validation complète**

```bash
# Si tout fonctionne, installer définitivement
cd ~/dotfiles-test
./bootstrap.sh

# Nettoyer
rm -rf ~/.zshrc.old
```

---

## 🐛 Problèmes courants

### macOS

#### Erreur : "command not found: brew"

**Solution :**
```bash
# Ajouter Homebrew au PATH manuellement
eval "$(/opt/homebrew/bin/brew shellenv)"  # Apple Silicon
# ou
eval "$(/usr/local/bin/brew shellenv)"     # Intel

# Puis relancer bootstrap
./bootstrap.sh
```

### Tous les systèmes

#### Erreur : "Permission denied"

**Solution :**
```bash
# Donner les permissions d'exécution
chmod +x bootstrap.sh update.sh test.sh
chmod +x src/**/*.sh
```

### Zinit ne charge pas les plugins

**Solution :**
```bash
# Supprimer le cache et recharger
rm -rf ~/.local/share/zinit
exec zsh
```

### Tmux plugins ne s'installent pas

**Solution :**
```bash
# Réinstaller TPM
rm -rf ~/.config/tmux/plugins/tpm
sh ~/.dotfiles/src/tmux-tmp.sh

# Dans Tmux : Ctrl+Space + I
```

---

## 📚 Prochaines étapes

Maintenant que l'installation est terminée :

1. **[[Configuration]]** - Découvrir la configuration générale
2. **[[Zsh-Configuration]]** - Personnaliser votre shell
3. **[[Tmux-Configuration]]** - Maîtriser Tmux
4. **[[Performance-Optimizations]]** - Comprendre les optimisations

---

**Besoin d'aide ?** → Consultez [[Troubleshooting]] ou [[FAQ]]

