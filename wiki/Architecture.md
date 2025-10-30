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
  1. Détection OS (uname + /etc/os-release)
  2. Vérification prérequis (git, curl)
  3. Liens symboliques (.config/)
  4. Installation paquets (brew/dnf/pacman)
  5. Configuration shell (historique XDG)
  6. Plugins (Tmux TPM, asdf)
  7. Config OS (macOS: GCC cache)
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
install/
├── lib/utils.sh              # Fonctions communes
├── link_global.sh            # Liens symboliques
├── macOS/packages.sh         # Paquets macOS
└── arch/packages.sh          # Paquets Arch
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
    macos) sh install/macOS/packages.sh ;;
    arch)  sh install/arch/packages.sh ;;
esac
```

---

## 🧩 Structure modulaire

```
.dotfiles/
├── bootstrap.sh          # Point d'entrée
├── update.sh             # Mise à jour
├── test.sh               # Tests
│
├── install/
│   ├── lib/
│   │   ├── utils.sh              # Fonctions communes
│   │   └── install_packages.sh   # Installation unifiée
│   │
│   ├── packages/
│   │   ├── macos.txt             # Paquets macOS
│   │   └── arch.txt              # Paquets Arch
│   │
│   ├── common/
│   │   ├── link_global.sh        # Liens symboliques
│   │   ├── shell.sh              # Migration shell XDG
│   │   ├── tmux-tmp.sh           # TPM
│   │   └── asdf-install.sh       # asdf plugins
│   │
│   ├── macOS/
│   │   ├── homebrew.sh           # Homebrew
│   │   ├── packages.sh           # Install paquets
│   │   ├── osx.sh                # Préférences système
│   │   └── refresh-gcc-cache.sh  # Cache GCC
│   │
│   └── arch/packages.sh
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

