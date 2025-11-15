# 🏗️ Architecture

Architecture technique du dotfiles.

## 📋 Table des matières

1. [Vue d'ensemble](#vue-densemble)
2. [Philosophie](#philosophie)
3. [Détection OS](#détection-os)
4. [Structure modulaire](#structure-modulaire)

---

## 🎯 Vue d'ensemble

**Principes :**
- **Portable** : macOS, Arch Linux
- **Modulaire** : Scripts à responsabilité unique
- **Performant** : Shell startup < 200ms
- **Idempotent** : Safe de relancer plusieurs fois

**Flux d'installation :**
```
bootstrap.sh
  1. Liens symboliques (.config/)
  2. Homebrew et paquets (Brewfile)
  3. Migration shell (historique XDG)
  4. Tmux Plugin Manager
  5. Plugins asdf
  6. Configuration macOS (Dock, Finder, screenshots)
  7. Cache GCC
```

---

## 💡 Philosophie

### POSIX sh (Portabilité)

**Pourquoi :** Compatible partout (bash, zsh, etc)

```bash
# ✅ POSIX sh
#!/bin/sh
. file.sh
[ -f file ]

# ❌ Bash-specific
#!/bin/bash
source file.sh
[[ -f file ]]
```

### Modularité

**Principe :** Un script = une responsabilité

```
src/
├── setup/
│   ├── link_global.sh        # Liens symboliques
│   ├── migration_shell.sh    # Migration historique XDG
│   ├── tmux.sh              # Tmux Plugin Manager
│   └── asdf.sh              # Plugins asdf
├── macOS/
│   ├── homebrew.sh          # Homebrew + paquets
│   ├── osx.sh               # Préférences système
│   └── refresh-gcc-cache.sh # Cache GCC
└── arch/
    └── packages.sh          # Paquets Arch
```

### Idempotence

**Principe :** Safe de relancer

```bash
# Vérifier avant d'agir
if [ -d "$TPM_DIR" ]; then
    exit 0
fi
git clone ...
```

### Performance

**Cible :** Shell startup < 200ms

- Plugins Zsh async
- Cache GCC (évite `brew --prefix`)
- Zinit turbo mode
- 4 plugins seulement

---

## 🖥️ Détection OS

**Méthode :** `uname -s` + `/etc/os-release`

```bash
# 1. macOS vs Linux
case "$(uname -s)" in
    Darwin*) OS_TYPE="macos" ;;
    Linux*)  # Étape 2 ;;
esac

# 2. Distribution Linux
if [ -f /etc/os-release ]; then
    . /etc/os-release
    case "$ID" in
        arch) OS_TYPE="arch" ;;
    esac
fi

export OS_TYPE
```

**Utilisation :**
```bash
case "$OS_TYPE" in
    macos) sh src/macOS/homebrew.sh ;;
    arch)  sh src/arch/packages.sh ;;
esac
```

---

## 🧩 Structure modulaire

```
.dotfiles/
├── bootstrap.sh          # Point d'entrée
├── test.sh               # Tests
│
├── Brewfile              # Paquets macOS (auto-maintenu)
├── .tool-versions        # Versions asdf
│
├── src/
│   ├── setup/
│   │   ├── link_global.sh      # Liens symboliques
│   │   ├── migration_shell.sh  # Migration historique XDG
│   │   ├── tmux.sh            # Tmux Plugin Manager
│   │   └── asdf.sh            # Plugins asdf
│   │
│   ├── macOS/
│   │   ├── homebrew.sh         # Homebrew + paquets (Brewfile)
│   │   ├── osx.sh              # Préférences système
│   │   └── refresh-gcc-cache.sh # Cache GCC
│   │
│   └── arch/
│       ├── packages.sh         # Install paquets
│       └── arch.txt            # Paquets Arch
│
└── .config/
    ├── shell/
    │   ├── env           # Variables
    │   └── aliases       # Aliases
    ├── git/
    ├── tmux/
    └── zsh/
```

**Principe :** Un script = une responsabilité

---

## 📚 Voir aussi

- [[Scripts-Reference]] - Détails scripts
- [[Configuration]] - Structure config
- [[Customization-Guide]] - Personnalisation

