
Configuration personnelle (shell, tmux, git, terminaux, outils) pour **macOS**. Les fichiers sont centralisés sous `~/.config` (XDG) et reliés par des liens symboliques.

---

## Prérequis

- **Mac à puce Apple Silicon** (M1, M2, M3, etc.) avec **macOS 26 (Tahoe) ou supérieur**.
- **Xcode Command Line Tools** (pour `git`, etc.).

---

## Installation (macOS)

```bash
git clone git@github.com:Raf7c/dotfiles.git ~/.dotfiles

cd ~/.dotfiles
./bootstrap.sh
```

Le script `bootstrap.sh` :

1. Détecte l’OS (macOS uniquement).
2. Lance dans l’ordre :
   - **osx.sh** — réglages système (Dock, Finder, captures d’écran, etc.)
   - **brew.sh** — installation de Homebrew puis des paquets du **Brewfile**
   - **asdf.sh** — installation des versions définies dans **.tool-versions**
   - **links.sh** — création des liens symboliques vers `~/.config` et `~`
   - **tmux.sh** — installation de TPM (Tmux Plugin Manager)
   - **shell.sh** — migration des historiques shell vers XDG

Redémarre le shell pour charger la config.

---

## Contenu par composant

| Composant | Description |
|-----------|-------------|
| **Zsh** | Historique XDG, env/aliases partagés, Zinit (completions, autosuggest, syntax-highlighting, fzf-tab), zoxide, fzf, Starship. |
| **Bash** | Même env/aliases, zoxide, fzf, Starship (sans Zinit). |
| **Env** | Homebrew (macOS), XDG, asdf, TERM, EDITOR, PAGER. |
| **Tmux** | Prefix Ctrl+Space, splits s/v, resize hjkl, zoom m, thème Mocha/Latte selon système, TPM. |
| **Git** | User, exclude, diff, fetch, etc. — voir `.config/git/config`. |
| **Kitty** | JetBrains Mono, Catppuccin auto (light/dark), padding, opacité, copier sur sélection. Voir `.config/kitty/README.md`. |
| **Ghostty** | Thème Latte/Mocha auto, Monaspace/JetBrains, même philosophie que Kitty. |
| **Starship** | Prompt minimal, formats par langage. |
| **asdf** | Versions dans `.tool-versions` : neovim, nodejs, python, golang, pnpm. |

---

## Scripts optionnels

- **scritps/tools42.sh** — Installe **norminette** (42 school) et **c_formatter_42** via pip (utilise le Python asdf si le script est lancé depuis un shell où asdf est chargé). Usage : `./scritps/tools42.sh`.

---

## Mise à jour

```bash
cd ~/.dotfiles
git pull
```

On peux relancer `./bootstrap.sh` pour réappliquer les liens et mises à jour (brew, asdf). Les changements de config (zsh, tmux, kitty, etc.) sont pris en compte au prochain lancement du shell ou après rechargement.

---

## Licence

Voir [LICENSE](LICENSE).
