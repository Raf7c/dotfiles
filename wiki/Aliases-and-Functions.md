# ⚡ Aliases et Fonctions

Référence des aliases et fonctions shell disponibles.

## 📋 Table des matières

1. [Aliases de base](#aliases-de-base)
2. [Aliases Git](#aliases-git)
3. [Fonctions utiles](#fonctions-utiles)
4. [Ajouter tes propres](#ajouter-tes-propres)

---

## 🔧 Aliases de base

**Fichier :** `.config/shell/aliases`

### Généraux

| Alias | Commande |
|-------|----------|
| `cl` | `clear` |

### Navigation & Listing

| Alias | Commande | Description |
|-------|----------|-------------|
| `cd` | `z` | zoxide (intelligent) |
| `ls` | `eza --icons` | Liste avec icônes |
| `ll` | `eza -l --icons --git` | Détaillée + Git |
| `la` | `eza -la --icons --git` | Tout + cachés |
| `lt` | `eza --tree --level=2 --icons` | Arbre 2 niveaux |

**Exemples :**
```bash
cd my-proj    # zoxide saute au dossier (après 1ère visite)
ll            # Liste détaillée avec statut Git
la            # Inclut fichiers cachés
lt            # Vue arbre
```

### Éditeurs

| Alias | Commande |
|-------|----------|
| `vim` | `nvim` |
| `vi` | `nvim` |

---

## 🌿 Aliases Git

**Détails complets :** [[Git-Configuration]]

| Catégorie | Aliases |
|-----------|---------|
| **Basique** | `gi` `gs` `ga` `gaa` `gc` `gcm` |
| **Branches** | `gb` `gbd` `gcb` `gco-` |
| **Remote** | `gps` `gpu` `gf` `gfa` |
| **Diff/Log** | `gd` `gds` `gl` `gla` |

**Workflow rapide :**
```bash
gs && gaa && gcm "message" && gps
```

---

## 🍎 Aliases macOS

| Alias | Description |
|-------|-------------|
| `brewup` | Update Homebrew + upgrade + cleanup + GCC cache |

**Cache GCC :** Alias auto-générés pour `gcc-15`, `g++-15`, etc.

---

## 🔧 Fonctions utiles

**Je n'ai pas encore configuré de fonctions.**

### Exemples simples

```bash
# Créer dossier + cd
mkcd() { mkdir -p "$1" && cd "$1"; }

# Backup rapide
backup() { cp "$1" "$1.backup.$(date +%Y%m%d-%H%M%S)"; }
```

---

## 💡 Ajouter tes propres

**Aliases :** Éditer `~/.config/shell/aliases`
```bash
alias mon_alias='ma_commande'
```

**Fonctions :** Créer `~/.config/shell/functions` puis charger dans `~/.config/shell/env`
```bash
ma_fonction() { echo "Hello"; }
```

**Recharger :** `exec zsh`

---

## 📚 Voir aussi

- [[Cheatsheet]] - Raccourcis Zsh et Tmux
- [[Zsh-Configuration]] - Config Zsh
- [[Tmux-Configuration]] - Config Tmux
- [[Git-Configuration]] - Aliases Git complets
