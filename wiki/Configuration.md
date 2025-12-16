# ⚙️ Configuration

Structure et organisation des dotfiles.

---

## 📁 Structure

```
~/.dotfiles/
├── .config/          # Configurations XDG
│   ├── bat/          # Coloration syntaxique
│   ├── ghostty/      # Terminal
│   ├── git/          # Git config
│   ├── nvim/         # Neovim (submodule)
│   ├── shell/        # Aliases et variables
│   ├── tmux/         # Tmux config
│   └── starship.toml # Prompt
├── zsh/              # Zsh config
├── bash/             # Bash config
├── src/              # Scripts d'installation
│   ├── setup/        # Scripts généraux
│   └── macOS/        # Scripts macOS
├── bootstrap.sh      # Script principal
├── Brewfile          # Paquets Homebrew
└── .tool-versions    # Versions asdf
```

---

## 🔗 Liens symboliques

Le script crée ces liens :

```bash
~/.config/bat         → ~/.dotfiles/.config/bat
~/.config/tmux        → ~/.dotfiles/.config/tmux
~/.config/nvim        → ~/.dotfiles/.config/nvim
~/.config/starship.toml → ~/.dotfiles/.config/starship.toml
~/.config/ghostty     → ~/.dotfiles/.config/ghostty
~/.config/shell       → ~/.dotfiles/.config/shell
~/.config/git         → ~/.dotfiles/.config/git
~/.zshrc              → ~/.dotfiles/zsh/.zshrc
~/.zprofile           → ~/.dotfiles/zsh/.zprofile
~/.bashrc             → ~/.dotfiles/bash/.bashrc
~/.bash_profile       → ~/.dotfiles/bash/.bash_profile
~/.tool-versions      → ~/.dotfiles/.tool-versions
~/.vimrc              → ~/.dotfiles/.vimrc
~/iCloudDrive         → ~/Library/Mobile Documents/com~apple~CloudDocs
```

---

## 🐚 Shell

### Zsh
- **Config :** `~/.zshrc`
- **Plugins :** Zinit (lazy loading)
- **Prompt :** Starship
- **Historique :** `~/.local/state/zsh/history`

### Variables d'environnement
- **Fichier :** `.config/shell/env`
- **XDG :** Conforme aux standards

### Aliases
- **Fichier :** `.config/shell/aliases`
- **Exemples :** `ll`, `la`, `gs`, `ga`, `gcm`

---

## 🖥️ Tmux

- **Config :** `.config/tmux/tmux.conf`
- **Préfixe :** `Ctrl+Space`
- **Thème :** Catppuccin (Mocha/Latte)
- **Plugins :** TPM, vim-tmux-navigator, resurrect, continuum

---

## 🎨 Thème

**Catppuccin** partout :
- Terminal (Ghostty)
- Tmux
- Neovim
- Bat

**Variantes :**
- Mocha (sombre)
- Latte (clair)

---

## 📦 Paquets

Gérés via **Homebrew** (`Brewfile`) :
- CLI tools : bat, eza, fzf, ripgrep, fd, zoxide
- Dev tools : git, gcc, make, asdf
- Apps : ghostty, cursor

---

## 🔧 Personnalisation

### Ajouter un alias

```bash
# Éditer
vim ~/.config/shell/aliases

# Ajouter
alias mon_alias="ma_commande"

# Recharger
source ~/.zshrc
```

### Ajouter une variable

```bash
# Éditer
vim ~/.config/shell/env

# Ajouter
export MA_VARIABLE="valeur"

# Recharger
source ~/.zshrc
```

### Modifier le prompt

```bash
# Éditer
vim ~/.config/starship.toml

# Recharger
exec zsh
```

---

**Plus d'infos :** [[Installation]] · [[FAQ]]
