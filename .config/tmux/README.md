# Configuration Tmux

Configuration de [Tmux](https://github.com/tmux/tmux) avec thèmes Catppuccin (Mocha / Latte), choix du thème selon l’apparence système, prefix Ctrl+Space, raccourcis type vim et TPM (plugins).

---

## Fichiers

| Fichier | Rôle |
|---------|------|
| `tmux.conf` | Config principale : prefix, rechargement, chargement du thème selon l’OS, inclusion des autres fichiers. |
| `options.conf` | Shell par défaut, couleurs, index des fenêtres, souris, scrollback, clipboard, mode-keys vi. |
| `keybindings.conf` | Raccourcis : splits `s` / `v`, nouvelle fenêtre `c`, resize hjkl, zoom `m`. |
| `plugins.conf` | TPM et plugins (vim-tmux-navigator, resurrect, continuum). |
| `themes/mocha.conf` | Thème Catppuccin Mocha (mode sombre). |
| `themes/latte.conf` | Thème Catppuccin Latte (mode clair). |

---

## Thème automatique (clair / sombre)

Au **démarrage** de tmux (ou au rechargement de la config), le thème est choisi selon l’apparence système :

- **macOS** : si l’interface est en mode sombre → **Mocha**, sinon → **Latte**.
- **Linux (GNOME)** : si le schéma de couleurs préfère le sombre → **Mocha**, sinon → **Latte**.

Tmux ne détecte pas les changements en direct (contrairement à Kitty ou Ghostty). Si tu changes le mode clair/sombre du système en cours de session :

- Recharge la config avec **prefix + r** : le `if-shell` est réévalué et le bon thème (Mocha ou Latte) est chargé.

---

## Raccourcis (prefix = Ctrl+Space)

| Raccourci | Action |
|-----------|--------|
| **prefix + r** | Recharger `tmux.conf` (et donc le thème si l’apparence a changé). |
| **prefix + s** | Split horizontal (nouveau panneau à droite). |
| **prefix + v** | Split vertical (nouveau panneau en bas). |
| **prefix + c** | Nouvelle fenêtre (dans le répertoire courant). |
| **prefix + m** | Agrandir / restaurer le panneau actif (zoom). |
| **prefix + j / k / h / l** | Redimensionner le panneau (vim-style, répétable). |

En mode copie (vi), les déplacements et la recherche suivent les touches vim.

---

## Plugins (TPM)

- **tmux-plugins/tpm** — Gestionnaire de plugins.
- **christoomey/vim-tmux-navigator** — Navigation entre panneaux et vim avec Ctrl+h/j/k/l.
- **tmux-plugins/tmux-resurrect** — Sauvegarde/restauration des sessions (contenu des panneaux inclus).
- **tmux-plugins/tmux-continuum** — Restauration automatique au démarrage.

**Installer TPM** : il faut d’abord cloner TPM dans le dossier tmux :
```bash
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
```

(Le script `install/macos/tmux.sh` fait cette étape automatiquement sur macOS.)

**Installer les plugins** : une fois TPM en place, lancer tmux et taper **prefix + I** (majuscule) pour installer les plugins listés dans `plugins.conf`.

---

## Références

- [Tmux — Documentation](https://github.com/tmux/tmux/wiki)
- [TPM — Tmux Plugin Manager](https://github.com/tmux-plugins/tpm)
- [Catppuccin](https://github.com/catppuccin/catppuccin)
