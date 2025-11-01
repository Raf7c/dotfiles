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

**Étapes :**
1. Détection OS (macOS/Arch)
2. Vérification prérequis (git, curl)
3. Liens symboliques
4. Gestionnaire paquets (Homebrew si macOS)
5. Installation paquets
6. Migration shell vers XDG
7. Tmux Plugin Manager
8. Plugins asdf
9. Config OS (GCC cache macOS)

**Log :** `~/.dotfiles/install.log`  
**Durée :** 3-10 min  
**Idempotent :** ✅ Oui

---

### update.sh

**Met à jour paquets et plugins**

```bash
./update.sh
```

**Actions (selon OS) :**
- **macOS** : Homebrew + cache GCC
- **Arch** : Pacman update
- **Tous** : asdf, Zinit, Tmux plugins

**Durée :** 30s - 5 min  
**Fréquence :** Hebdomadaire

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
sh src/common/setup/link_global.sh
```

**Liens :** `.config/git`, `.config/tmux`, `.config/shell`, `.zshrc`, `.tool-versions`, etc.

---

### shell.sh

**Migre historique shell vers XDG_STATE_HOME**

- Zsh : `~/.zsh_history` → `~/.local/state/zsh/history`
- Bash : `~/.bash_history` → `~/.local/state/bash/history`
- Backup automatique avant suppression
- Migration automatique depuis `~/.local/share/` si nécessaire

**Emplacement :** `src/common/shell/shell.sh`

---

### tmux.sh

**Installe Tmux Plugin Manager**

Clone TPM dans `~/.config/tmux/plugins/tpm`

**Post-install :** `Ctrl+Space I` dans Tmux

**Emplacement :** `src/common/tools/tmux.sh`

---

### asdf.sh

**Installe plugins asdf depuis `.tool-versions`**

**Exemple `.tool-versions` :**
```
neovim 0.11.4
python 3.14.0
```

**Emplacement :** `src/common/tools/asdf.sh`

---

## 📚 Utilitaires

### utils.sh

**Fonctions communes**

```bash
detect_os()       # Détecte OS (macos|arch)
command_exists()  # Vérifie commande
print_success()   # Message ✅
print_error()     # Message ❌
print_warning()   # Message ⚠️
run_step()        # Exécute script avec gestion erreur
```

---

### package_manager.sh

**Installation unifiée paquets**

```bash
install_packages() {
    local os="$1"           # macos | arch
    local packages_dir_or_file="$2"
    local pkg_file="${3:-}" # Optionnel (Arch)
}
```

**Commandes par OS :**
- **macOS** : `brew bundle install --file=Brewfile`
- **Arch** : `sudo pacman -S --noconfirm --needed`

---

## 🖥️ Scripts OS

### macOS

| Script | Description |
|--------|-------------|
| `homebrew.sh` | Installe Homebrew |
| `packages.sh` | Installe paquets depuis `Brewfile` |
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
bash -x ./bootstrap.sh
sh -x src/common/setup/link_global.sh

# Vérifier syntaxe
sh -n bootstrap.sh
```

---

## 📚 Voir aussi

- [[Installation]] - Guide installation
- [[Architecture]] - Architecture technique
- [[Troubleshooting]] - Dépannage
