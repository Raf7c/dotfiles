# ⚡ Cheatsheet - Référence Rapide

Guide de référence ultra-rapide des commandes et raccourcis les plus utilisés.

---

## 📋 Top 20 Alias

### Navigation & Listing
```bash
cd <dir>      # Navigation intelligente (zoxide)
ls            # Liste avec icônes
ll            # Liste détaillée + Git
la            # Liste tout (cachés inclus)
lt            # Arborescence 2 niveaux
```

### Git - Basique
```bash
gi            # git init
gs            # git status
ga .          # git add .
gaa           # git add --all
gap           # git add --patch
gc            # git commit
gcm "msg"     # git commit -m "msg"
gps           # git push
gpu           # git pull
```

### Git - Branches
```bash
gb            # Lister branches
gba           # Lister toutes branches (remote inclus)
gbr           # Lister branches remote
gcb <name>    # git checkout -b (créer nouvelle branche)
gco-          # Retour branche précédente
gbd <branch>  # Supprimer branche
```

### Git - Diff & Historique
```bash
gd            # git diff
gds           # git diff --staged
gf            # git fetch
gfa           # git fetch --all
gl            # git log --oneline
gla           # git log --oneline --all --graph
```

### Divers
```bash
cl            # clear (nettoyer écran)
vim           # nvim (Neovim)
vi            # nvim (Neovim)
```

### Dotfiles
```bash
cd ~/.dotfiles && ./update.sh  # Mettre à jour dotfiles
cd ~/.dotfiles && ./test.sh    # Tester installation
```

### macOS
```bash
brewup        # brew update + upgrade + cleanup + refresh GCC cache
```

---

## ⌨️ Raccourcis Zsh

### Ligne de commande
| Raccourci | Action |
|-----------|--------|
| `Ctrl+a` | Début de ligne |
| `Ctrl+e` | Fin de ligne |
| `Ctrl+u` | Effacer jusqu'au début |
| `Ctrl+k` | Effacer jusqu'à la fin |
| `Ctrl+w` | Effacer mot précédent |
| `Ctrl+l` | Clear (nettoyer écran) |
| `Ctrl+r` | Recherche historique (fzf) |

### FZF (Recherche floue)
| Raccourci | Action |
|-----------|--------|
| `Ctrl+t` | Rechercher fichier |
| `Ctrl+r` | Rechercher historique |
| `Alt+c` | Rechercher dossier (cd) |
| `Ctrl+/` | Toggle preview |

### Navigation
| Raccourci | Action |
|-----------|--------|
| `Alt+←` | Mot précédent |
| `Alt+→` | Mot suivant |
| `Ctrl+←` | Début du mot |
| `Ctrl+→` | Fin du mot |

---

## 🖥️ Raccourcis Tmux

### Préfixe
**Préfixe personnalisé :** `Ctrl+Space` (appuyer avant chaque commande)

### Sessions
| Raccourci | Action |
|-----------|--------|
| `tmux` | Nouvelle session |
| `tmux ls` | Lister sessions |
| `tmux attach` | Attacher dernière session |
| `Prefix + d` | Détacher session |
| `Prefix + $` | Renommer session |

### Fenêtres (Windows)
| Raccourci | Action |
|-----------|--------|
| `Prefix + c` | Nouvelle fenêtre |
| `Prefix + ,` | Renommer fenêtre |
| `Prefix + n` | Fenêtre suivante |
| `Prefix + p` | Fenêtre précédente |
| `Prefix + 0-9` | Aller à fenêtre N |
| `Prefix + &` | Fermer fenêtre |

### Panes (Panneaux)
| Raccourci | Action |
|-----------|--------|
| `Prefix + s` | Split horizontal |
| `Prefix + v` | Split vertical |
| `Prefix + x` | Fermer pane |
| `Prefix + z` | Zoom/Dezoom pane |
| `Prefix + {` | Déplacer pane à gauche |
| `Prefix + }` | Déplacer pane à droite |

### Navigation Vim-like (vim-tmux-navigator)
| Raccourci | Action |
|-----------|--------|
| `Ctrl+h` | Pane gauche (fonctionne dans Vim/Tmux) |
| `Ctrl+j` | Pane bas |
| `Ctrl+k` | Pane haut |
| `Ctrl+l` | Pane droite |

### Copier/Coller
| Raccourci | Action |
|-----------|--------|
| `Prefix + [` | Mode copie (vi) |
| `v` | Début sélection |
| `y` | Copier sélection |
| `Prefix + ]` | Coller |

### Configuration et plugins
| Raccourci | Action |
|-----------|--------|
| `Prefix + r` | Recharger la configuration |
| `Prefix + I` | Installer les plugins TPM (majuscule) |
| `Prefix + U` | Mettre à jour les plugins |

### Tmux Resurrect
| Raccourci | Action |
|-----------|--------|
| `Prefix + Ctrl+s` | Sauvegarder session |
| `Prefix + Ctrl+r` | Restaurer session |

---

## 🔧 Commandes Outils CLI

### bat (cat amélioré)
```bash
bat file.txt              # Afficher avec coloration
bat -n file.txt           # Avec numéros de ligne
bat -p file.txt           # Plain (sans déco)
bat -A file.txt           # Montrer caractères invisibles
bat -r 10:20 file.txt     # Lignes 10-20
```

### fzf (recherche floue)
```bash
ls | fzf                  # Recherche interactive
vim $(fzf)                # Ouvrir fichier avec fzf
cd $(fd -t d | fzf)       # cd avec fzf
```

### ripgrep (grep rapide)
```bash
rg "pattern"              # Rechercher pattern
rg -i "pattern"           # Insensible à la casse
rg -l "pattern"           # Seulement noms de fichiers
rg -t py "pattern"        # Seulement fichiers Python
rg -A 3 "pattern"         # Avec 3 lignes après
```

### fd (find simplifié)
```bash
fd pattern                # Rechercher fichiers
fd -t f pattern           # Seulement fichiers
fd -t d pattern           # Seulement dossiers
fd -e txt                 # Extension .txt
fd -H pattern             # Inclure cachés
fd -E node_modules        # Exclure dossier
```

### eza (ls moderne)
```bash
ll                        # Liste détaillée + Git
la                        # Tout afficher (cachés inclus)
lt                        # Arborescence 2 niveaux
eza --tree --level=3      # Arborescence 3 niveaux
eza -lah --sort=size      # Tri par taille
eza -lah --sort=modified  # Tri par date
```

### zoxide (cd intelligent)
```bash
z docs                    # Jump vers dossier contenant "docs"
zi                        # Recherche interactive
z -                       # Retour dossier précédent
```

### btop (moniteur système)
```bash
btop                      # Lancer moniteur
# Dans btop:
# Esc = Menu
# q   = Quitter
# f   = Filtrer processus
```

---

## 🚀 Commandes Dotfiles

### Installation & Mise à jour
```bash
# Installation initiale
cd ~/.dotfiles
./bootstrap.sh

# Mise à jour
./update.sh

# Test
./test.sh
```

### Édition rapide
```bash
# Éditer config Zsh
vim ~/.zshrc
vim ~/.config/zsh/zinit.zsh

# Éditer aliases
vim ~/.config/shell/aliases

# Éditer variables d'environnement
vim ~/.config/shell/env

# Éditer config Tmux
vim ~/.config/tmux/tmux.conf

# Éditer config Starship
vim ~/.config/starship.toml
```

### Recharger configs
```bash
# Recharger Zsh
exec zsh
# ou
source ~/.zshrc

# Recharger Tmux (dans tmux)
Prefix + r

# Recharger Tmux (depuis terminal)
tmux source ~/.config/tmux/tmux.conf
```

---

## 🐛 Debug Rapide

### Performance
```bash
# Temps de démarrage Zsh
time zsh -i -c exit
# → Devrait être < 0.2s (200ms)

# Profiler Zsh (détaillé)
zprof
```

### Variables
```bash
# Vérifier OS_TYPE
echo $OS_TYPE
# → macos / fedora / arch

# Vérifier XDG
echo $XDG_CONFIG_HOME
# → ~/.config

# Vérifier PATH
echo $PATH | tr ':' '\n'
```

### Git
```bash
# Vérifier config
git config --list

# Vérifier remote
git remote -v

# Vérifier branche courante
git branch --show-current
```

---

## 📚 Liens Utiles

- **[Installation complète](Installation)** - Guide détaillé
- **[Tous les alias](Aliases-and-Functions)** - Liste complète
- **[Troubleshooting](Troubleshooting)** - Résolution de problèmes
- **[FAQ](FAQ)** - Questions fréquentes

---

**💡 Astuce :** Garde cette page en favoris pour accès rapide !

