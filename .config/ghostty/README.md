# Configuration Ghostty

Configuration du terminal [Ghostty](https://ghostty.org/) avec thèmes Catppuccin (Mocha / Latte) et bascule automatique selon le mode clair/sombre du système.

---

## Fichiers

| Fichier | Rôle |
|---------|------|
| `config` | Config unique : thème auto, police, padding, souris, flou, copier sur sélection. |

Ghostty gère nativement le thème automatique via l’option `theme = light:...,dark:...`. Aucun fichier de couleurs séparé ni script externe.

---

## Thème automatique (clair / sombre)

Dans `config` :

```ini
theme = light:Catppuccin Latte,dark:Catppuccin Mocha
```

- **Mode système clair** → Ghostty utilise **Catppuccin Latte**.
- **Mode système sombre** → Ghostty utilise **Catppuccin Mocha**.

Le changement est automatique quand tu modifies l’apparence dans les réglages du système (macOS : Réglages Système > Apparence ; Linux : selon l’environnement).

Pour utiliser d’autres thèmes, remplace les noms dans la même syntaxe `light:Thème clair,dark:Thème sombre`. Les thèmes disponibles dépendent de ton installation Ghostty.

---

## Options principales

| Option | Description |
|--------|-------------|
| `macos-option-as-alt` | Touche Option comme Alt (macOS ; ignoré sur Linux). |
| `window-padding-x` / `window-padding-y` | Marge autour du terminal. |
| `font-family` / `font-size` | Police et taille. |
| `background-blur-radius` | Flou d’arrière-plan. |
| `background-opacity` | Opacité du fond. |
| `copy-on-select` | Copier dans le presse-papiers lors d’une sélection. |
| `mouse-hide-while-typing` | Masquer le curseur pendant la frappe. |

---

## Changer de thème manuellement

Tu peux surcharger temporairement en éditant `config` et en mettant par exemple :

```ini
theme = Catppuccin Mocha
```

Puis redémarrer Ghostty ou recharger la config si l’option est supportée.

---

## Références

- [Ghostty — Documentation](https://ghostty.org/docs)
- [Catppuccin](https://github.com/catppuccin/catppuccin)
