# 🌿 Configuration Git

Configuration Git avec gitignore global et aliases shell.

## 📋 Table des matières

1. [Configuration](#configuration)
2. [Gitignore global](#gitignore-global)
3. [Aliases](#aliases)
4. [Utilisation](#utilisation)

---

## ⚙️ Configuration

**Fichier :** `.config/git/config`

### Options principales

```ini
[user]
    name = Raphaël C
    email = 122828688+Raf7c@users.noreply.github.com

[init]
    defaultBranch = main

[core]
    excludesFile = ~/.config/git/ignore

[diff]
    algorithm = histogram      # Meilleur algo
    colorMoved = plain         # Détecte déplacements
    renames = true             # Détecte renommages

[fetch]
    prune = true              # Nettoie branches supprimées
    pruneTags = true          # Nettoie tags supprimés

[branch]
    sort = -committerdate     # Tri par date (récentes en premier)

[commit]
    verbose = true            # Affiche diff lors du commit
```

**⚠️ À personnaliser :** Change `user.name` et `user.email` !

## 📝 Gitignore global

**Fichier :** `.config/git/ignore`

```
# macOS
.DS_Store

# Editors
.vscode/
.idea/

# Env
.env
.env.local
```

Ignoré dans **tous** les projets Git.

---

## 🔗 Aliases

**Fichier :** `.config/shell/aliases`

### Basiques

```bash
gi='git init'
gs='git status'
ga='git add'
gaa='git add --all'
gc='git commit'
gcm='git commit -m'
```

### Branches

```bash
gb='git branch'
gbd='git branch --delete'
gcb='git checkout -b'       # Créer et checkout
gco-='git checkout -'        # Retour branche précédente
```

### Remote

```bash
gps='git push'
gpu='git pull'
gf='git fetch'
gfa='git fetch --all'
```

### Diff & Log

```bash
gd='git diff'
gds='git diff --staged'
gl='git log --oneline'
gla='git log --oneline --all --graph'
```

---

## 💡 Utilisation

### Workflow rapide

```bash
gs                        # Status
gaa && gcm "mon message"  # Add all + commit
gps                       # Push
```

### Personnaliser

```bash
# Éditer config
nvim ~/.config/git/config

# Ou via CLI
git config --global user.name "Votre Nom"
git config --global user.email "votre@email.com"
```

---

## 📚 Voir aussi

- [[Configuration]] - Configuration générale
- [[Aliases-and-Functions]] - Tous les aliases

