# 📦 Configuration Tmux

Configuration Tmux avec TPM et thème Catppuccin.

## 📋 Table des matières

1. [Vue d'ensemble](#vue-densemble)
2. [Structure](#structure)
3. [Raccourcis](#raccourcis)
4. [Plugins TPM](#plugins-tpm)
5. [Thème](#thème)
6. [Optimisations](#optimisations)
7. [Personnalisation](#personnalisation)

---

## 🎯 Vue d'ensemble

**Prefix :** `Ctrl+Space` (au lieu de `Ctrl+b`)  
**Features :** Modulaire · Plugins TPM · Catppuccin · vim-tmux-navigator  
**Performance :** Historique optimisé · Status bar 5s

---

## 📁 Structure

```
.config/tmux/
├── tmux.conf         # Point d'entrée
├── options.conf      # Options + prefix + perf
├── keybindings.conf  # Raccourcis
├── plugins.conf      # TPM
└── themes/
    ├── mocha.conf    # Sombre (Catppuccin)
    └── latte.conf    # Clair (Catppuccin)
```

**tmux.conf :** Charge tous les fichiers + switch thème automatique (macOS)

**Options principales :**
```bash
# Prefix
set-option -g prefix C-Space

# Numérotation à partir de 1
set -g base-index 1
set -g pane-base-index 1

# Performance
set -g history-limit 50000     # 50K lignes
set -g status-interval 5       # Status toutes les 5s
set -sg escape-time 0          # Pas de délai ESC

# Vi mode + souris
setw -g mode-keys vi
set -g mouse on
```

---

## ⌨️ Raccourcis

**Prefix :** `Ctrl+Space

### Fenêtres

| Raccourci | Action |
|-----------|--------|
| `<Prefix> c` | Nouvelle fenêtre |
| `<Prefix> n/p` | Fenêtre suivante/précédente |
| `<Prefix> 1-9` | Aller à fenêtre N |
| `<Prefix> ,` | Renommer |
| `<Prefix> &` | Fermer |

### Panes

| Raccourci | Action |
|-----------|--------|
| `<Prefix> s` | Split horizontal |
| `<Prefix> v` | Split vertical |
| `<Prefix> x` | Fermer |
| `<Prefix> z` | Zoom/Dézoom |
| `Ctrl+h/j/k/l` | Navigation (vim-tmux-navigator) |
| `<Prefix> H/J/K/L` | Redimensionner |

### Sessions

| Raccourci | Action |
|-----------|--------|
| `<Prefix> d` | Détacher |
| `<Prefix> s` | Liste sessions |
| `<Prefix> $` | Renommer |

**CLI :**
```bash
tmux ls                   # Lister
tmux attach -t <name>     # Attacher
tmux new -s <name>        # Nouvelle
tmux kill-session -t <name>  # Tuer
```

### Mode copie (Vi)

| Raccourci | Action |
|-----------|--------|
| `<Prefix> [` | Entrer en mode copie |
| `v` | Sélection |
  `V` | Sélection ligne |
| `y` | Copier |
| `<Prefix> ]` | Coller |

### Plugins

| Raccourci | Action |
|-----------|--------|
| `<Prefix> r` | Recharger config |
| `<Prefix> I` | Installer plugins |
| `<Prefix> U` | Mettre à jour |

---

## 🔌 Plugins TPM

**TPM** = Tmux Plugin Manager

**Installation** via `src/setup/tmux.sh`

| Plugin | Description | Raccourcis |
|--------|-------------|------------|
| **vim-tmux-navigator** | Navigation Vim ↔ Tmux | `Ctrl+hjkl` |
| **tmux-resurrect** | Sauvegarde/restore sessions | `<Prefix> Ctrl+s` / `<Prefix> Ctrl+r` |
| **tmux-continuum** | Sauvegarde auto toutes les 15min | Automatique |

**Sauvegarde :** Layout · Répertoires · Programmes (vim, nvim) · Historique  
**Emplacement :** `~/.local/share/tmux/resurrect/`

---

## 🎨 Thème

**Catppuccin** - Mocha (sombre) · Latte (clair)  
**Switch auto :** Basé sur apparence système macOS et Linux

**Status bar :**
- Position : Top · Centre
- Gauche : Session name
- Centre : Fenêtres avec numéros
- Droite : Hostname

---

## ⚡ Optimisations

| Optimisation            | Config            | Gain |
|--------------           |--------|          ------|
| Historique | `50000` lignes (au lieu de 1M) | -95% mémoire |
| Status bar | Refresh 5s                     | -80% CPU |
| Escape time | `0` (pas de délai ESC)        | Réactivité Vim/Neovim |
| Thème | Variables couleur                   | Calculs évités |

---

## 🎨 Personnalisation

### Changer le prefix
**Fichier :** `options.conf`
```bash
set-option -g prefix C-b  # Revenir à Ctrl+b
```

### Ajouter un raccourci
**Fichier :** `keybindings.conf`
```bash
bind-key -T copy-mode-vi C-a send-keys -X select-line
```

### Changer le thème
**Fichier :** `tmux.conf`
```bash
source-file ~/.config/tmux/themes/mocha.conf  # Toujours mocha
```

### Ajouter un plugin
**Fichier :** `plugins.conf`
```bash
set -g @plugin 'tmux-plugins/tmux-yank'
```
**Installer :** `<Prefix> I`

---

## 🐛 Dépannage

### Plugins ne s'installent pas
```bash
rm -rf ~/.config/tmux/plugins/tpm
sh ~/.dotfiles/src/setup/tmux.sh
# Dans Tmux : Ctrl+Space + I
```

### Couleurs incorrectes
```bash
echo $TERM  # Devrait être "tmux-256color"
```

### Navigation Vim
Installer dans Neovim : `christoomey/vim-tmux-navigator`

### Sessions non restaurées
```bash
ls -la ~/.local/share/tmux/resurrect/  # Vérifier sauvegardes
<Prefix> Ctrl+r  # Restaurer manuellement
```

---

## 📚 Voir aussi

- [[Zsh-Configuration]] - Zsh
- [[Git-Configuration]] - Git
- [Tmux Manual](https://man.openbsd.org/tmux)
- [TPM Docs](https://github.com/tmux-plugins/tpm)

