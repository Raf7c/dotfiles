# tmux

Raccourcis, thème, presse-papiers, plugins.

Préfixe : **`Ctrl-Space`** (`C-b` délié). Touches vi partout.

## Raccourcis

### Sessions, fenêtres, panneaux

| Touche | Action |
|---|---|
| `prefix r` | recharge tmux.conf |
| `prefix b` | découpe horizontale, même répertoire |
| `prefix v` | découpe verticale, même répertoire |
| `prefix c` | nouvelle fenêtre, même répertoire |
| `Ctrl-h/j/k/l` | navigue entre les panneaux **et** les splits nvim |
| `prefix h/j/k/l` | redimensionne le panneau de 5 (répétable) |
| `prefix m` | zoom du panneau (bascule) |
| `prefix Shift-←/→` | déplace la fenêtre à gauche / à droite (répétable) |

### Mode copie (touches vi)

| Touche | Action |
|---|---|
| `v` | commence la sélection |
| `V` | sélection de ligne |
| `Ctrl-v` | sélection rectangulaire |
| `y` / `Enter` | copie et sort |
| `Esc` | efface la sélection |
| `prefix P` | colle le buffer tmux |

Le glissé de souris ne copie **pas** automatiquement. C'est délibéré : la
sélection survit au relâchement du bouton.

### Sessions enregistrées

| Touche | Action |
|---|---|
| `prefix Ctrl-s` | enregistre maintenant |
| `prefix Ctrl-r` | restaure |

L'enregistrement est automatique toutes les 15 minutes, et la restauration se
fait au démarrage du serveur. Le contenu des panneaux revient aussi, sessions
nvim comprises.

## Thème

Barre de statut écrite à la main sur la palette
[Catppuccin](https://github.com/catppuccin/catppuccin), pas le plugin officiel.
Deux fichiers dans `themes/`, zéro dépendance.

Le choix se fait **au démarrage du serveur**, d'après l'apparence de l'OS.
`TMUX_THEME=light|dark` le force. Après une bascule clair/sombre de l'OS,
`prefix r` réapplique.

<details>
<summary>Le fallback, et pourquoi le choix n'est pas continu</summary>

L'apparence vient de `defaults` (macOS) ou `gsettings` (GNOME). Quand c'est
indétectable — ssh, serveur sans écran — le fallback est **mocha** : une barre
pâle serait illisible, alors que l'inverse se lit encore.

Aucune réévaluation continue. C'est manuel à dessein : un hook par OS coûterait
plus qu'il ne rapporte.

</details>

## Presse-papiers

Chaque assistant de copie est **sondé** avant usage : pbcopy (macOS), wl-copy
(Wayland), xclip (X11).

Si aucun n'existe, la sélection tmux sert de fallback, et `set-clipboard on`
émet quand même de l'OSC 52. Le terminal reçoit donc la copie, SSH compris,
sans aucun binaire côté distant.

## Plugins

Via TPM, clonés dans `plugins/`, gitignoré. `prefix I` installe, `prefix U` met
à jour.

| Plugin | Rôle |
|---|---|
| [tpm](https://github.com/tmux-plugins/tpm) | gestionnaire de plugins |
| [vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator) | `Ctrl-h/j/k/l` à travers tmux *et* nvim |
| [tmux-resurrect](https://github.com/tmux-plugins/tmux-resurrect) | enregistre/restaure les sessions |
| [tmux-continuum](https://github.com/tmux-plugins/tmux-continuum) | enregistrement auto, restauration au démarrage |
| [tmux-cpu-mem-monitor](https://github.com/hendrikmi/tmux-cpu-mem-monitor) | cpu / mém / disque dans la barre (a besoin de python3) |

Non épinglés, même politique que zinit :
[docs/architecture.md](../../docs/architecture.md).

<details>
<summary>Deux notes sur ces plugins</summary>

**cpu-mem-monitor** est tenu par une seule personne, accepté en connaissance de
cause : il ne publie aucun tag à épingler, et l'exposition reste bornée à
`prefix I` / `prefix U`. Sans lui, ou sans python3, la barre est simplement
plus courte. Rien d'autre n'en dépend.

**resurrect** écrit dans `~/.local/share/tmux/resurrect/`, posé explicitement.
Le plugin va déjà par défaut vers XDG, sauf quand `~/.tmux/resurrect` survit
d'une installation plus ancienne, auquel cas il y retourne.

</details>

<details>
<summary>Les réglages de fond de tmux.conf</summary>

| Réglage | Pourquoi |
|---|---|
| fenêtres et panneaux à partir de 1 | renumérotés à la fermeture |
| 100k lignes d'historique par panneau | le scrollback, c'est de la RAM |
| `escape-time 10` | défaut amont depuis la 3.5, remède aux raccourcis `M-` capricieux à 0 |
| `focus-events` | autoread de nvim |
| `allow-passthrough` | séquences OSC à travers tmux |
| `detach-on-destroy off` | détruire la dernière session bascule vers une autre |

</details>
