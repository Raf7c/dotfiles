# 🐚 Configuration Zsh

Configuration Zsh avec Zinit, plugins async et optimisations de performance.

## 📋 Table des matières

1. [Vue d'ensemble](#vue-densemble)
2. [Structure](#structure)
3. [Plugins Zinit](#plugins-zinit)
4. [Historique](#historique)
5. [Complétions](#complétions)
6. [Intégrations](#intégrations)
7. [Optimisations](#optimisations)
8. [Personnalisation](#personnalisation)

---

## 🎯 Vue d'ensemble

**Performance :** Démarrage < 200ms  
**Features :** Zinit · Plugins async · Complétions · Starship prompt

**Fichiers :**
- `zsh/.zprofile` → Homebrew + PATH (login)
- `zsh/.zshrc` → Config interactive + plugins
- `zsh/zinit.zsh` → Gestionnaire de plugins

---

## 📁 Structure

### .zprofile (Login)

Chargé 1 fois au login : Homebrew + PATH

```bash
# Homebrew (macOS)
eval "$(/opt/homebrew/bin/brew shellenv)"

# Local bin
export PATH="$HOME/.local/bin:$PATH"
```

### .zshrc (Interactif)

Chargé à chaque shell : Config + Plugins + Intégrations

```bash
# 1. Variables d'environnement
source ~/.config/shell/env

# 2. Historique
HISTFILE="$XDG_DATA_HOME/zsh/history"
HISTSIZE=10000
setopt sharehistory hist_ignore_all_dups

# 3. Homebrew + asdf completions (FPATH)
FPATH="/opt/homebrew/share/zsh/site-functions:$FPATH"

# 4. Aliases
source ~/.config/shell/aliases

# 5. Zinit + plugins
source ~/zsh/zinit.zsh

# 6. Intégrations
eval "$(starship init zsh)"
eval "$(fzf --zsh)"
eval "$(zoxide init zsh)"
```

### zinit.zsh (Plugins)

```bash
# Auto-install Zinit
ZINIT_HOME="$XDG_DATA_HOME/zinit/zinit.git"
[ ! -d "$ZINIT_HOME/.git" ] && \
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"

source "$ZINIT_HOME/zinit.zsh"

# Plugin critique (sync)
zinit load zsh-users/zsh-completions

# Plugins non-critiques (async)
zinit wait lucid for \
    zsh-users/zsh-autosuggestions \
    zsh-users/zsh-syntax-highlighting

# fzf-tab
zinit light Aloxaf/fzf-tab

# Complétions
autoload -Uz compinit
compinit -C -d "$XDG_CACHE_HOME/zsh/.zcompdump"
```

---

## 🔌 Plugins Zinit

**Zinit** = Gestionnaire de plugins ultra-rapide (auto-install, async, mises à jour)

### Liste des plugins

| Plugin | Description | Mode |
|--------|-------------|------|
| **zsh-completions** | Complétions 200+ commandes (docker, npm, cargo...) | Sync |
| **zsh-autosuggestions** | Suggestions depuis historique (`→` pour accepter) | Async |
| **zsh-syntax-highlighting** | Coloration syntaxique (vert=valide, rouge=invalide) | Async |
| **fzf-tab** | Complétions interactives avec preview | Normal |

### Utilisation

```bash
# Autosuggestions
$ git pus_
      ↑ suggestion grisée → Appuyer sur → pour accepter

# fzf-tab
$ cd ~/<TAB>  # Ouvre interface interactive avec preview eza
```

---

## 📜 Historique

**Config :** 10000 lignes · Fichier XDG · Partagé entre sessions · Sans doublons

```bash
HISTFILE="$XDG_DATA_HOME/zsh/history"
HISTSIZE=10000
setopt sharehistory hist_ignore_all_dups
```

**Recherche :** `Ctrl+R` (fzf)

**Commandes utiles :**
```bash
history          # Voir historique
history -20      # 20 dernières
!!               # Dernière commande
!git             # Dernière commençant par git
```

---

## 🎯 Complétions

**Init :** `compinit -C` (cache XDG · Skip vérif sécurité)

**Styles :**
```bash
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'  # Insensible casse
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"  # Couleurs
zstyle ':completion:*' menu no                           # Utilise fzf-tab
```

**Sources :**
- Built-ins: `cd`, `kill`, `ssh`
- Homebrew: `brew`, `git`
- zsh-completions: `docker`, `npm`, `cargo`, `pip`
- asdf: `asdf`

**Usage :** `<TAB>` pour compléter avec fzf-tab interactif

---

## 🔗 Intégrations

### Starship (Prompt)
**Init :** `eval "$(starship init zsh)"`  
**Config :** `.config/starship.toml`  

### fzf (Fuzzy Finder)
**Init :** `eval "$(fzf --zsh)"`  
**Raccourcis :**
- `Ctrl+r` → Historique
- `Ctrl+t` → Fichiers
- `Alt+c` → Dossiers


### zoxide (Smart cd)
**Init :** `eval "$(zoxide init zsh)"`  
**Usage :** `cd proj` → Jump intelligent vers ~/projects  

---

## ⚡ Optimisations

### 1. Chargement async
```bash
zinit wait lucid for \
    zsh-users/zsh-autosuggestions \
    zsh-users/zsh-syntax-highlighting
```
**Gain :** Shell utilisable immédiatement

### 2. Cache complétion
```bash
compinit -C -d "$XDG_CACHE_HOME/zsh/.zcompdump"
```
**Gain :** Skip vérif sécurité (50-100ms)

### 3. $OSTYPE au lieu de uname
```bash
case "$OSTYPE" in darwin*) ... ;; esac  # ✅ Rapide
```
**Gain :** ~10ms par appel

### 4. Ordre de chargement
```
1. Variables env
2. Historique
3. FPATH (Homebrew, asdf)
4. Aliases
5. Zinit + plugins
6. compinit (après FPATH)
7. Intégrations (starship, fzf, zoxide)
```

**Résultat :** < 200ms de démarrage

---

## 🎨 Personnalisation

### Ajouter un alias
**Fichier :** `.config/shell/aliases`
```bash
alias mycommand='echo "Hello"'
```
**Recharger :** `source ~/.zshrc`

### Ajouter une variable
**Fichier :** `.config/shell/env`
```bash
export MY_VAR="value"
```

### Ajouter un plugin Zinit
**Fichier :** `zsh/zinit.zsh`
```bash
zinit light username/plugin-name       # Normal
zinit wait lucid for username/plugin  # Async
```

### Changer Starship
**Fichier :** `.config/starship.toml`  
**Presets :** [starship.rs/presets](https://starship.rs/presets/)

---

## 🐛 Dépannage

### Zinit ne se charge pas
```bash
rm -rf ~/.local/share/zinit && exec zsh
```

### Complétions cassées
```bash
rm ~/.cache/zsh/.zcompdump* && exec zsh
```

### Shell lent
```bash
time zsh -i -c exit  # Benchmarker
```

### Suggestions absentes
```bash
zinit list | grep autosuggestions  # Vérifier
zinit delete zsh-users/zsh-autosuggestions && exec zsh  # Réinstaller
```

---

## 📚 Voir aussi

- [[Configuration]] - Configuration générale
- [[Tmux-Configuration]] - Tmux
- [Zinit Docs](https://github.com/zdharma-continuum/zinit)
- [Starship Docs](https://starship.rs/config/)

