# 🏠 dotfiles

Configuration macOS pour un environnement de développement. Les fichiers sont centralisés sous `~/.config` (XDG) et reliés par des liens symboliques.

**Supporté :** macOS

📚 [Wiki complet](https://github.com/Raf7c/dotfiles/wiki)

---

## 📋 Table des matières

- [Prérequis](#-prérequis)
- [Installation rapide](#-installation-rapide)
- [Documentation](#-documentation)
- [Contenu](#-contenu)
- [Scripts optionnels](#-scripts-optionnels)
- [Mise à jour](#-mise-à-jour)
- [Licence](#-licence)

---

## 🔧 Prérequis

### macOS

- **Version :** macOS 26 Tahoe
- **Architecture :** Apple Silicon (M1/M2/M3/M4)
- **Requis :** Xcode Command Line Tools (git, etc.)

---

## 🚀 Installation rapide

```bash
git clone git@github.com:Raf7c/dotfiles.git ~/.dotfiles

cd ~/.dotfiles
./bootstrap.sh
```

**Ce que fait `bootstrap.sh` :**

1. **osx.sh** — Réglages système (Dock, Finder, captures d’écran, heure 24h, etc.)
2. **brew.sh** — Installe Homebrew si besoin, puis les paquets du `Brewfile`
3. **asdf.sh** — Installe les plugins et versions définis dans `.tool-versions` (neovim, nodejs, python, golang, pnpm)
4. **links.sh** — Crée les liens symboliques vers `~/.config` et `~` (.zshrc, .bashrc, .tool-versions)
5. **tmux.sh** — Installe le Tmux Plugin Manager (TPM) dans `~/.config/tmux/plugins/tpm`
6. **shell.sh** — Migre les historiques shell vers les répertoires XDG

Redémarre ton shell pour charger la config.

---

## 📚 Documentation

| 📄 Guide | 📝 Description |
|----------|----------------|
| [Installation](https://github.com/Raf7c/dotfiles/wiki/Installation) | Installation pas à pas |
| [Configuration](https://github.com/Raf7c/dotfiles/wiki/Configuration) | Structure du dépôt, XDG, env |
| [Configuration Zsh](https://github.com/Raf7c/dotfiles/wiki/Zsh-Configuration) | Zinit, plugins, Starship |
| [Configuration Tmux](https://github.com/Raf7c/dotfiles/wiki/Tmux-Configuration) | Raccourcis, TPM, thèmes |
| [Configuration Git](https://github.com/Raf7c/dotfiles/wiki/Git-Configuration) | Config globale, ignore |
| [Guide CLI](https://github.com/Raf7c/dotfiles/wiki/CLI-Tools-Guide) | bat, eza, fzf, zoxide, etc. |
| [Dépannage](https://github.com/Raf7c/dotfiles/wiki/Troubleshooting) | Problèmes courants et solutions |
| [FAQ](https://github.com/Raf7c/dotfiles/wiki/FAQ) | Questions fréquentes |
| [Aide-mémoire](https://github.com/Raf7c/dotfiles/wiki/Cheatsheet) | Raccourcis tmux, aliases |

README par composant : [Kitty](.config/kitty/README.md) · [Ghostty](.config/ghostty/README.md) · [Tmux](.config/tmux/README.md)

---

## 🛠️ Contenu

### Principal

| Composant | Description |
|-----------|-------------|
| **Zsh** | Historique XDG, env/aliases partagés, Zinit (completions, autosuggest, syntax-highlighting, fzf-tab), zoxide, fzf, Starship. |
| **Bash** | Même env/aliases, zoxide, fzf, Starship (sans Zinit). |
| **Tmux** | Préfixe `Ctrl+Space`, splits `s`/`v`, resize hjkl, zoom `m`, Catppuccin Mocha/Latte (auto selon l’apparence système), TPM. |
| **Kitty** | JetBrains Mono, Catppuccin auto (clair/sombre), padding, opacité, copier sur sélection. |
| **Ghostty** | Catppuccin Latte/Mocha auto, même philosophie que Kitty. |
| **Git** | User, exclude, diff, fetch — voir `.config/git/config`. |
| **Starship** | Prompt minimal, formats par langage. |
| **asdf** | Versions dans `.tool-versions` : neovim, nodejs, python, golang, pnpm. |

### CLI (Brewfile)

`git` · `tmux` · `zsh` · `eza` · `bat` · `fzf` · `zoxide` · `starship` · `ripgrep` · `fd` · `asdf` · …

### Caractéristiques

- **Orientation macOS** — Détection OS, réglages système, Homebrew
- **Conforme XDG** — Config sous `~/.config`, état sous `~/.local/state`
- **Modulaire** — Scripts dans `install/macos/`, config dans `.config/`
- **Idempotent** — On peut relancer `bootstrap.sh` sans risque

---

## 📜 Scripts optionnels

- **scritps/tools42.sh** — Installe **norminette** (42 school) et **c_formatter_42** via pip. Utilise le Python asdf si le script est lancé depuis un shell où asdf est chargé.  
  Usage : `./scritps/tools42.sh`

---

## 🔄 Mise à jour

```bash
cd ~/.dotfiles
git pull
./bootstrap.sh
```

Relancer `bootstrap.sh` met à jour les liens, les paquets Homebrew, les versions asdf et TPM si besoin. Les changements de config (zsh, tmux, kitty, etc.) sont pris en compte au prochain lancement du shell ou après rechargement.

---

## 📝 Licence

[Licence MIT](LICENSE).

---