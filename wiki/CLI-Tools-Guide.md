# ⚡ Guide des Outils CLI

Outils CLI

## 📋 Table des matières

1. [bat](#bat) - cat avec coloration
2. [eza](#eza) - ls avec icônes
3. [fzf](#fzf) - recherche floue
4. [ripgrep](#ripgrep) - grep rapide
5. [fd](#fd) - find simplifié
6. [zoxide](#zoxide) - cd intelligent
7. [starship](#starship) - prompt


---

## 🦇 bat

**cat** avec coloration syntaxique et numéros de ligne

### Usage

```bash
bat file.py              # Afficher
bat -n file.py           # Avec numéros
bat -p file.py           # Plain (sans déco)
bat -r 10:20 file.py     # Lignes 10-20
```

### Intégrations

```bash
# Preview fzf
fzf --preview 'bat --color=always {}'

# Git diff
git diff | bat

# Ripgrep
rg "pattern" -l | xargs bat
```

**Thème :**  (configuré dans `BAT_THEME`)

---

## 📁 eza

**ls** moderne avec icônes, couleurs et Git

### Alias configurés

```bash
ll    # eza -lah --icons --git
la    # eza -a --icons
lt    # eza --tree --level=2 --icons
```

### Commandes utiles

```bash
eza --tree --level=3        # Arbre
eza -lah --sort=size        # Tri taille
eza -lah --sort=modified    # Tri date
eza -lah --only-files       # Fichiers seulement
eza -lah --only-dirs        # Dossiers seulement
eza -lah --git              # Statut Git
```

---

## 🔍 fzf

Recherche floue interactive

### Raccourcis Zsh

| Raccourci | Action |
|-----------|--------|
| `ctrl+t` | Fichiers |
| `ctrl+r` | Historique |


### Workflows

```bash
# Ouvrir fichier
nvim $(fzf)

# Checkout branch
git branch | fzf | xargs git checkout

# Kill processus
ps aux | fzf | awk '{print $2}' | xargs kill

# Preview
fzf --preview 'bat --color=always {}'
```

**Config :** Utilise `fd` + Catppuccin (déjà configuré)

---

## 🔎 ripgrep

**grep** Recherche de texte ultra-rapide

### Commandes

```bash
rg "pattern"                # Recherche
rg -i "pattern"             # Insensible casse
rg "pattern" --type py      # Type fichier
rg "error" -C 3             # ±3 lignes contexte
rg "TODO" --count           # Compter
rg "error" -l               # Lister fichiers
rg "pattern" -g '!node_modules'  # Ignorer dossier
```

### Intégration fzf

```bash
# Recherche interactive
rg --line-number --color=always . | fzf --ansi
```

---

## 🔎 fd

**find** simplifié et rapide

### Commandes

```bash
fd filename               # Trouver
fd -e py                  # Extension .py
fd -t f                   # Fichiers
fd -t d                   # Dossiers
fd -E node_modules        # Exclure
fd --max-depth 2          # Profondeur max
fd -e pyc -x rm {}        # Exec commande
fd --changed-within 24h   # Modifié <24h
```

### Intégrations

```bash
# Avec fzf
fd | fzf --preview 'bat --color=always {}'

# Ouvrir fichier
nvim $(fd -e md | fzf)
```

---

## 🚀 zoxide

**cd** intelligent qui apprend tes habitudes

### Usage

```bash
# Première fois
cd ~/Projects/my-project

# Ensuite, de partout :
z proj              # Jump intelligent
zi                  # Recherche interactive
zoxide query -l     # Voir historique
```

**Alias :** `cd` est aliasé à `z` (déjà configuré)

---

## ✨ starship

Prompt minimal et rapide

**Config :** `~/.config/starship.toml`

**Modules :** Dossier · Git · Langages (Python, Rust, Node) · Durée commande

### Personnalisation

```toml
[directory]
truncation_length = 3

[character]
success_symbol = "[➜](bold green)"
error_symbol = "[✗](bold red)"
```

**Presets :** `starship preset --list`

---

## 🔗 Workflows

```bash
# Trouver + éditer
nvim $(fd -e md | fzf)

# Rechercher + éditer
nvim $(rg -l "TODO" | fzf)

# Jump + ouvrir
z project && nvim

# Recherche + preview
rg "pattern" | fzf --preview 'bat {1}:{2}'
```

---

## 📚 Voir aussi

- [[Cheatsheet]] - Commandes rapides
- [[Aliases-and-Functions]] - Tous les aliases
- [[Configuration]] - Configuration
