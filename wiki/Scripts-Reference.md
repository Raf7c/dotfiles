# 📜 Référence des Scripts

Documentation des scripts d'installation.

## 📋 Table des matières

1. [Scripts principaux](#scripts-principaux)
2. [Scripts installation](#scripts-installation)
3. [Scripts OS](#scripts-os)
4. [Utilitaires](#utilitaires)

---

## 🚀 Scripts principaux

### bootstrap.sh

**Installation complète de l'environnement**

```bash
./bootstrap.sh
```

**Étapes (dans l'ordre) :**
1. Liens symboliques (`src/setup/link_global.sh`)
2. Homebrew et paquets (`src/macOS/homebrew.sh`)
3. Migration shell vers XDG (`src/setup/migration_shell.sh`)
4. Tmux Plugin Manager (`src/setup/tmux.sh`)
5. Plugins asdf (`src/setup/asdf.sh`)
6. Configuration macOS (`src/macOS/osx.sh`)
7. Cache GCC (`src/macOS/refresh-gcc-cache.sh`)

**Durée :** 3-10 min  
**Idempotent :** ✅ Oui

---


### test.sh

**Valide l'installation**

```bash
./test.sh
```

**Vérifie :**
- OS détecté
- Commandes essentielles (git, curl, tmux, gcc, make)
- Outils CLI (bat, eza, fzf, ripgrep, fd, starship, zoxide)
- Gestionnaire paquets
- asdf + plugins
- Liens symboliques
- Variables environnement

**Durée :** <5s

---

## 📦 Scripts installation

### link_global.sh

**Crée les liens symboliques**

```bash
sh src/setup/link_global.sh
```

**Liens :** `.config/git`, `.config/tmux`, `.config/shell`, `.zshrc`, `.tool-versions`, etc.

**Emplacement :** `src/setup/link_global.sh`

---

### migration_shell.sh

**Migre historique shell vers XDG_STATE_HOME**

- Zsh : `~/.zsh_history` → `~/.local/state/zsh/history`
- Bash : `~/.bash_history` → `~/.local/state/bash/history`
- Migration automatique depuis `~/.local/share/` si nécessaire
- Crée un fichier vide si l'historique n'existe pas

**Emplacement :** `src/setup/migration_shell.sh`

---

### tmux.sh

**Installe Tmux Plugin Manager**

Clone TPM dans `~/.config/tmux/plugins/tpm` si absent.

**Post-install :** `Ctrl+Space I` dans Tmux

**Emplacement :** `src/setup/tmux.sh`

---

### asdf.sh

**Installe plugins asdf depuis `.tool-versions`**

**Exemple `.tool-versions` :**
```
neovim 0.11.4
python 3.14.0
```

**Emplacement :** `src/setup/asdf.sh`

---


## 🖥️ Scripts OS

### macOS

| Script | Description |
|--------|-------------|
| `homebrew.sh` | Installe Homebrew et paquets depuis `Brewfile` |
| `osx.sh` | Configure préférences système (Dock, Finder, screenshots) |
| `refresh-gcc-cache.sh` | Génère cache aliases GCC (évite `brew --prefix`) |

**Format Brewfile :**
```bash
# Paquets
brew "git"
brew "bat"

# Apps (casks)
cask "ghostty"
cask "font-jetbrains-mono-nerd-font"
```

---

### Arch

| Script | Description |
|--------|-------------|
| `packages.sh` | `sudo pacman -S` depuis `src/arch/arch.txt` |

---

## 🐛 Debugging

```bash
# Mode verbose
sh -x ./bootstrap.sh
sh -x src/setup/link_global.sh

# Vérifier syntaxe
sh -n bootstrap.sh
```

---

## 📚 Voir aussi

- [[Installation]] - Guide installation
- [[Architecture]] - Architecture technique
- [[Troubleshooting]] - Dépannage
