# Configuration Kitty

Configuration du terminal [Kitty](https://sw.kovidgoyal.net/kitty/) avec thèmes Catppuccin (Mocha / Latte) et bascule automatique selon le mode clair/sombre du système.

---

## Fichiers

| Fichier | Rôle |
|---------|------|
| `kitty.conf` | Config principale (police, padding, souris, etc.) + include du thème par défaut. |
| `dark-theme.auto.conf` | Couleurs appliquées **automatiquement** quand le système est en mode sombre. |
| `light-theme.auto.conf` | Couleurs appliquées **automatiquement** quand le système est en mode clair. |

Kitty charge tout seul `dark-theme.auto.conf` ou `light-theme.auto.conf` selon l’apparence système (macOS, Linux GNOME, etc.). Pas besoin de script externe.

---

## Procédure : configurer le changement automatique de thème (kitten themes)

Pour associer un thème au mode clair et un au mode sombre (ou refaire la config sur une autre machine) :

### 1. Lancer le kitten themes

Dans un terminal Kitty :

```bash
kitten themes
```

Un menu liste les thèmes disponibles.

### 2. Associer le thème clair (Latte)

1. Choisir **Catppuccin Kitty Latte** (ou **Catppuccin Latte** selon la liste).
2. Dans le menu qui s’affiche, choisir :
   - **Save as colors to use when the OS switches to: Light mode**
3. Kitty crée ou met à jour `light-theme.auto.conf` avec les couleurs Latte.

### 3. Associer le thème sombre (Mocha)

1. Quitter le menu (option **Quit**), relancer :
   ```bash
   kitten themes
   ```
2. Choisir **Catppuccin Kitty Mocha** (ou **Catppuccin Mocha**).
3. Choisir :
   - **Save as colors to use when the OS switches to: Dark mode**
4. Kitty crée ou met à jour `dark-theme.auto.conf` avec les couleurs Mocha.

### 4. Résultat

- **Mode système clair** → Kitty utilise `light-theme.auto.conf` (Latte).
- **Mode système sombre** → Kitty utilise `dark-theme.auto.conf` (Mocha).

Le changement est automatique quand tu modifies l’apparence dans les réglages du système (macOS : Réglages Système > Apparence ; Linux GNOME : Paramètres > Apparence).

---

## Autres options du menu kitten themes

Lors du choix d’un thème, le kitten peut proposer notamment :

- **Modify kitty.conf to load [thème]** — écrit un `include` dans `kitty.conf`. Utile si tu veux un thème fixe (sans auto).
- **Place the theme file in ~/.config/kitty but do not modify kitty.conf** — copie le fichier de thème sans toucher à `kitty.conf`.
- **Save as colors to use when the OS switches to: Dark / Light / No preference mode** — utilisé pour la bascule automatique (voir ci‑dessus).
- **Abort and return to list of themes** — annuler et revenir à la liste.
- **Quit** — quitter.

---

## Changer de thème manuellement

- **Menu interactif** : `kitten themes` puis choisir un thème (sans utiliser « Save as colors for OS… » si tu veux juste tester).
- **Recharger la config** : Ctrl+Shift+F5 dans Kitty (ou redémarrer Kitty).

---

## Références

- [Kitty — Configuring kitty](https://sw.kovidgoyal.net/kitty/)
- [Kitty — Changing kitty colors / themes](https://sw.kovidgoyal.net/kitty/kittens/themes/)
- [Catppuccin for Kitty](https://github.com/catppuccin/kitty)
