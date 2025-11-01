# ❓ FAQ (Foire Aux Questions)

Réponses aux questions fréquentes.

## 📋 Table des matières

1. [Questions générales](#questions-générales)
2. [Installation](#installation)
3. [Configuration](#configuration)
4. [Performance](#performance)
5. [Personnalisation](#personnalisation)

---

## 🏠 Questions Générales

### Qu'est-ce que des dotfiles ?

Les **dotfiles** sont les fichiers de configuration Unix/Linux qui commencent par un point (`.`), comme `.zshrc`, `.vimrc`, etc. Ils configurent le comportement de vos applications et outils en ligne de commande.

### Pourquoi utiliser des dotfiles ?

**Avantages :**
- ✅ Environnement reproductible sur plusieurs machines
- ✅ Sauvegarde de votre configuration
- ✅ Partage de meilleures pratiques
- ✅ Historique des changements (via Git)
- ✅ Installation automatisée

### Puis-je utiliser ces dotfiles sur Linux ?

**Oui !** Support complet pour :
- ✅ **Arch Linux** (Pacman + AUR via yay)
- ✅ **macOS 12.0+** (Homebrew)

Le script `bootstrap.sh` détecte automatiquement votre système d'exploitation et installe les paquets appropriés. Les fichiers de configuration (`.zshrc`, `.config/tmux`, etc.) sont identiques sur tous les systèmes.

### Est-ce que cela fonctionne sur Intel Mac ?

**Oui**, avec quelques ajustements :
- Homebrew s'installe dans `/usr/local/` au lieu de `/opt/homebrew/`
- Certains chemins dans `.zprofile` doivent être adaptés
- Les packages Homebrew sont généralement compatibles

### Quelle distribution Linux est supportée ?

**Actuellement supportées :**
- ✅ **Arch Linux** - Installation via Pacman
- ✅ **Dérivés Arch** - Manjaro, EndeavourOS (via Pacman)


Le script détecte automatiquement votre distribution via `/etc/os-release`.

### Quelles sont les différences entre les OS ?

**Identique sur tous les OS :**
- Configuration Zsh, Tmux, Git, Neovim
- Plugins et thèmes
- Aliases et fonctions shell
- Structure XDG

**Spécifique par OS :**
- Gestionnaire de paquets (Homebrew/DNF/Pacman)
- Certains paquets système (gcc vs gcc-c++)
- Emplacements de binaires
- Configuration système (macOS preferences, etc.)

---

## 🚀 Installation

### Dois-je sauvegarder mes configurations actuelles ?

**Oui, fortement recommandé !**

```bash
# Sauvegarder vos configurations actuelles
mkdir ~/dotfiles-backup
cp ~/.zshrc ~/dotfiles-backup/
cp ~/.vimrc ~/dotfiles-backup/
cp -r ~/.config ~/dotfiles-backup/
```

### Puis-je installer partiellement (seulement Zsh par exemple) ?

**Oui**, exécutez les scripts individuellement :

```bash
# Seulement les liens symboliques
sh src/link_global.sh

# Seulement Zsh (après liens)
# Rien de spécifique, juste relancer le shell
exec zsh
```

### Que faire si l'installation échoue ?

1. **Consulter le log**
```bash
cat ~/.dotfiles/install.log
```

2. **Voir [[Troubleshooting]]**

3. **Relancer bootstrap** (idempotent)
```bash
./bootstrap.sh
```

### Combien de temps prend l'installation ?

| Étape | Durée |
|-------|-------|
| Liens symboliques | ~5s |
| Homebrew (si pas installé) | 2-5 min |
| Packages | 2-7 min |
| Configuration & plugins | ~1 min |
| **Total** | **3-10 minutes** |

**Note :** Le temps varie selon votre connexion internet et si Homebrew est déjà installé. Première installation complète : 5-13 min.

---

## ⚙️ Configuration

### Comment ajouter mes propres aliases ?

**Éditer :** `.config/shell/aliases`

```bash
# Ajouter vos aliases
alias myalias='ma-commande'
```

**Recharger :**
```bash
source ~/.zshrc
```

### Comment changer le thème Tmux ?

**Éditer :** `.config/tmux/tmux.conf`

```bash
# Toujours utiliser mocha (sombre)
source-file ~/.config/tmux/themes/mocha.conf

# Ou toujours utiliser latte (clair)
source-file ~/.config/tmux/themes/latte.conf
```

**Recharger :**
```bash
<prefix> r  # Ctrl+Space puis r
```

### Comment désactiver un plugin Zsh ?

**Éditer :** `zsh/zinit.zsh`

```bash
# Commenter le plugin
# zinit light Aloxaf/fzf-tab
```

**Recharger :**
```bash
exec zsh
```

### Où sont stockés les historiques de shell ?

```
~/.local/share/zsh/history     # Historique Zsh
~/.local/share/bash/history    # Historique Bash
```

**Avantage :** Respect de XDG, home directory propre.

### Comment modifier les variables d'environnement ?

**Éditer :** `.config/shell/env`

```bash
export MA_VARIABLE="valeur"
```

**Recharger :**
```bash
source ~/.zshrc
```

---

## ⚡ Performance

### Mon shell est lent au démarrage (> 300ms)

**Solutions :**
1. Voir [[Performance-Optimizations]]
2. Profiler : `time zsh -i -c exit`
3. Désactiver plugins non utilisés
4. Nettoyer caches : `rm -rf ~/.cache/zsh/*`

### Comment mesurer le temps de démarrage ?

```bash
# Simple
time zsh -i -c exit

# Détaillé (avec hyperfine)
brew install hyperfine
hyperfine 'zsh -i -c exit' --warmup 3
```

### Tmux utilise beaucoup de mémoire

**Solutions :**
1. Réduire history-limit dans `options.conf`
2. Fermer les sessions non utilisées
3. Désactiver tmux-continuum si non nécessaire

### Pourquoi utiliser un cache GCC ?

Appeler `brew --prefix gcc` est lent (~50ms). Le cache évite cet appel à chaque démarrage de shell.

**Régénérer :**
```bash
sh ~/.dotfiles/src/macOS/refresh-gcc-cache.sh
```

---

## 🎨 Personnalisation

### Comment changer le prompt Starship ?

**Éditer :** `.config/starship.toml`

Voir les [presets officiels](https://starship.rs/presets/).

**Exemple - Prompt minimal :**
```toml
[character]
success_symbol = "[➜](bold green)"
error_symbol = "[➜](bold red)"
```

### Comment ajouter un plugin Zsh ?

**Éditer :** `zsh/zinit.zsh`

```bash
# Ajoutez avant compinit
zinit light username/nom-du-plugin
```

**Exemple :**
```bash
zinit light zsh-users/zsh-history-substring-search
```

### Comment personnaliser les couleurs Tmux ?

**Éditer :** `.config/tmux/themes/mocha.conf` (ou latte.conf)

**Exemple :**
```bash
# Changer la couleur de la status bar
set -g status-bg "#votre-couleur"
```

### Comment désactiver la souris dans Tmux ?

**Éditer :** `.config/tmux/options.conf`

```bash
# Désactiver la souris
set -g mouse off
```

---

## 🔧 Avancé

### Puis-je utiliser Bash au lieu de Zsh ?

**Oui**, mais avec fonctionnalités limitées :
- Pas de Zinit (plugins Zsh)
- Pas de Starship prompt optimisé
- Complétions de base uniquement

**Configuration :** Les fichiers `bash/.bashrc` et `bash/.bash_profile` sont fournis.

### Comment synchroniser sur plusieurs machines ?

**Méthode 1 : Fork le repo**
```bash
# 1. Fork sur GitHub
# 2. Cloner votre fork
git clone https://github.com/VOTRE-USERNAME/.dotfiles.git ~/.dotfiles

# 3. Modifier et commit
git add .
git commit -m "Mes modifications"
git push
```

**Méthode 2 : Branches**
```bash
# Créer une branche pour votre machine
git checkout -b machine-perso

# Commit vos modifications
git add .
git commit -m "Config machine perso"
git push origin machine-perso
```

### Comment contribuer / proposer des améliorations ?

1. Fork le repository
2. Créer une branche feature
3. Commit vos changements
4. Ouvrir une Pull Request

### Comment revenir en arrière (rollback) ?

```bash
cd ~/.dotfiles

# Voir les commits récents
git log --oneline

# Revenir à un commit précédent
git checkout <commit-hash>

# Réinstaller
./bootstrap.sh

# Revenir au dernier commit
git checkout main
```

---

## 🐛 Dépannage

### Rien ne fonctionne après l'installation

**Checklist :**
1. Redémarrer le terminal complètement
2. Vérifier : `echo $SHELL` → `/bin/zsh`
3. Consulter le log : `cat ~/.dotfiles/install.log`
4. Voir [[Troubleshooting]]

### J'ai cassé ma configuration, comment réparer ?

**Restauration rapide :**
```bash
cd ~/.dotfiles
git reset --hard origin/main
./bootstrap.sh
```

### Puis-je désinstaller complètement ?

```bash
# Supprimer les liens symboliques
rm ~/.zshrc ~/.vimrc ~/.zprofile ~/.bashrc ~/.bash_profile
rm -rf ~/.config/git ~/.config/tmux ~/.config/shell ~/.config/bat

# Supprimer les données
rm -rf ~/.local/share/zinit
rm -rf ~/.config/tmux/plugins

# Optionnel : Supprimer le repo
rm -rf ~/.dotfiles

# Restaurer vos backups
cp ~/dotfiles-backup/.zshrc ~/.zshrc
# etc.
```

---

## 📚 Ressources

- **[[Home]]** - Page d'accueil du wiki
- **[[Installation]]** - Guide d'installation détaillé
- **[[Troubleshooting]]** - Dépannage
- **[README principal](../README.md)** - Vue d'ensemble

---

**Vous avez une autre question ?** Ouvrez une [issue](https://github.com/votre-username/.dotfiles/issues) !

