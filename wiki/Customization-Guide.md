# 🎨 Guide de personnalisation

Adapter le dotfiles à tes besoins.

## 📋 Table des matières

1. [Ajouter paquets](#ajouter-paquets)
2. [Créer aliases/fonctions](#créer-aliasesfonctions)
3. [Configurer Starship](#configurer-starship)
4. [Changer thème](#changer-thème)
5. [Ajouter plugins Zinit](#ajouter-plugins-zinit)

---

## 📦 Ajouter paquets

### Éditer le fichier packages

| OS | Fichier |
|----|---------|
| macOS | `Brewfile` (à la racine) |
| Arch | `src/arch/arch.txt` |

**Format macOS (Brewfile) :**
```bash
# CLI
brew "git"
brew "curl"
brew "nom-nouveau-paquet"

# Applications (casks)
cask "docker"
cask "font-jetbrains-mono-nerd-font"
```

**Format Arch (arch.txt) :**
```bash
# CLI
git
curl
nom-nouveau-paquet
```

### Installer

```bash
./bootstrap.sh  # Réinstallation complète
# ou
sh src/macOS/packages.sh  # macOS uniquement
```

---

## ⚡ Créer aliases/fonctions

**Détails complets :** [[Aliases-and-Functions]]

### Aliases

**Fichier :** `~/.config/shell/aliases`
```bash
alias mon_alias='ma_commande'
alias projects='cd ~/Projects'
alias v='nvim'
```

### Fonctions

**Fichier :** `~/.config/shell/functions`
```bash
mkcd() { mkdir -p "$1" && cd "$1"; }
backup() { cp "$1" "$1.backup.$(date +%Y%m%d-%H%M%S)"; }
```

**Charger :** Ajouter dans `~/.config/shell/env`
```bash
[ -f "$XDG_CONFIG_HOME/shell/functions" ] && . "$XDG_CONFIG_HOME/shell/functions"
```

**Recharger :** `exec zsh`

---

## ✨ Configurer Starship

**Fichier :** `~/.config/starship.toml`

### Exemples

```toml
# Prompt simple
[character]
success_symbol = "[➜](bold green)"
error_symbol = "[✗](bold red)"

# Dossier
[directory]
truncation_length = 3
style = "bold cyan"

# Git
[git_branch]
symbol = "🌿 "
style = "bold purple"
```

### Présets

```bash
starship preset --list
starship preset nerd-font-symbols > ~/.config/starship.toml
```

---

## 🎨 Changer le thème

**Actuel :** Catppuccin Mocha

### Variants Catppuccin

| Variant | Style |
|---------|-------|
| Mocha | Sombre (actuel) |
| Latte | Clair |
| Frappé | Sombre moyen |
| Macchiato | Sombre |

### Modifier

**bat :** Éditer `~/.config/shell/env`
```bash
export BAT_THEME="Catppuccin Latte"
```

**Ghostty :** Éditer `~/.config/ghostty/config`
```
theme = "catppuccin-latte"
```

---

## 🔌 Ajouter plugins Zinit

**Fichier :** `~/.config/zsh/zinit.zsh`

### Syntaxe

```bash
# Plugin simple
zinit light user/repo

# Avec turbo mode (chargement différé)
zinit ice wait lucid
zinit light user/repo
```

### Plugins utiles

| Plugin | Description |
|--------|-------------|
| `MichaelAquilina/zsh-you-should-use` | Suggère les alias |
| `hlissner/zsh-autopair` | Ferme parenthèses auto |
| `jeffreytse/zsh-vi-mode` | Mode Vi |

### Mettre à jour

```bash
zinit update --all
zinit self-update
```

---

## 📚 Voir aussi

- [[Aliases-and-Functions]] - Aliases complets
- [[Zsh-Configuration]] - Config Zsh
- [[Architecture]] - Structure des dotfiles

