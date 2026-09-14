# Maintenance

Ce qui garde ce dépôt honnête, et quoi faire quand une machine se tient mal.
Rien ici ne change une machine ; pour ça, voir [installer.md](installer.md).

## Quand quelque chose casse

Aucun script de health-check. Les vérifications qui comptent tiennent en une
commande chacune.

| Symptôme | Premier geste |
|---|---|
| un fichier zsh modifié, le shell part en erreur | `zsh -n ~/.zshenv ~/.config/zsh/.zshrc` |
| une config ignorée, un lien qui a l'air faux | `. setup/manifest.sh && dotfiles_links`, puis comparer avec `ls -l ~` |
| une installation a fait quelque chose d'inattendu | `./run install -n` : affiche chaque commande, n'écrit rien |
| des plugins manquent après un update | `./run upgrade`, puis `exec zsh` |
| `compinit` râle au démarrage sur un fichier absent | un lien de complétion est orphelin : `zinit cclear`, puis `exec zsh` |
| tmux ignore la config | `tmux kill-server` : les options sont lues une fois, au démarrage du serveur |
| vim indente avec des espaces | `vim --version`, puis `:verbose set expandtab?` |
| l'historique n'est pas enregistré | `ls -ld ~/.local/state/zsh ~/.local/state/bash` |
| une signature refuse de se vérifier | [security.md](security.md), les quatre contrôles |
| un fichier égaré dans `$HOME` | un outil ignore XDG : chercher une redirection dans `env.sh` ([outils.md](outils.md)) |

Les backups de chaque exécution :
`~/.local/state/dotfiles/backups/<horodatage>/`.

## Convention

**La documentation est corrigée dans le même commit que le code qu'elle
décrit.** Chaque audit de ce dépôt a trouvé le même mode de défaillance : une
correction qui atterrit à un endroit et pas dans son satellite.

## Ce que la CI vérifie

`.github/workflows/ci.yml`, à chaque push sur `main`/`dev` et à chaque pull
request.

| Contrôle | Portée |
|---|---|
| syntaxe | `zsh -n`, sur les fichiers zsh seulement |
| shellcheck | niveau warning et au-dessus |
| shfmt | contre `.editorconfig`, `-d` doit rester muet |
| yamllint | `.github` et `.yamllint.yml` lui-même |
| 5 contrôles maison | 2 sur le code, 3 sur cette documentation |

<details>
<summary>Pourquoi la syntaxe ne couvre que zsh</summary>

shellcheck refuse zsh — il répond `Unknown shell: zsh`. Les fichiers zsh
n'ont donc pas d'autre filet, et shfmt n'en est pas un : il lit du zsh
légitime comme `${(f)…}` comme une erreur.

Les fichiers `sh` et `bash` n'ont plus de passe `-n` : shellcheck rejette tout
ce que `dash -n` rejette, et cinq constructions de plus qu'il laissait passer
(`[[ ]]`, `echo -e`, `local`, `source`, `+=`). Mesuré sur les deux sens.

</details>

Les cinq contrôles maison :

| # | Ce qu'il attrape |
|---|---|
| 1 | un `exit` dans une étape sourcée |
| 2 | `STEPS` ↔ `setup/steps/`, dans les **deux** sens |
| 3 | un chemin du dépôt entre accents graves qui n'existe pas |
| 4 | un lien markdown interne qui ne résout pas |
| 5 | une page `docs/*.md` nommée depuis le **code** et qui n'existe pas |

> [!CAUTION]
> **Rejouer ces contrôles avec `bash`, jamais avec `zsh`.** zsh ne découpe pas
> une expansion de paramètre non quotée. Les contrôles 2 et 3 en dépendent :
> écrits naïvement, le premier crie au loup sur un arbre sain et le second rend
> 0 quoi que dise la doc, silencieusement.
>
> L'idiome qui marche partout : `case " $liste " in *" $item "*)`.

<details>
<summary>Pourquoi une série de contrôles sur la doc</summary>

La doc porte les seules affirmations qu'aucun test de shell ne peut
contredire : des chemins. Chacun de ces trois contrôles ferme un défaut précis,
déjà livré une fois : une page qui pointe vers un fichier déplacé, un chemin
cité entre accents graves qui a été supprimé, une fusion de deux pages qui a
laissé cinq références mortes dans des commentaires de code.

</details>

<details>
<summary>Deux formes de défaut restent hors de portée</summary>

Un nom de fichier racine cité sans barre oblique (`` `Brewfile-ancien` ``)
n'est pas décidable : la doc nomme légitimement des fichiers **absents**, par
exemple `` `.sops.yaml` `` dont [security.md](security.md) dit précisément
qu'il n'est pas ici.

Un chemin cité en prose sans accents graves n'est pas cherché du tout.

Les yeux restent nécessaires. Les cinq contrôles ferment seulement les formes
qui ont déjà mordu.

</details>

> [!CAUTION]
> Quand on lui donne un **répertoire**, shfmt saute silencieusement les
> dotfiles, et il n'a aucun drapeau pour les inclure. Chaque fichier zsh doit
> être nommé sur la ligne de commande, sinon il passe non vérifié sans un mot.

<details>
<summary>Comment la CI contourne ce piège, et pourquoi les versions sont épinglées</summary>

`find` liste les dotfiles, lui. L'étape syntaxe les atteint avec
`-name '.z*' -o -name '*.zsh'`, plus `.zshenv` écrit en toutes lettres, puisque
ce `find` ne parcourt que `.config/zsh`.

shfmt parcourt trois répertoires puis nomme un par un chaque fichier qu'un
parcours de répertoire sauterait. shellcheck en nomme deux des siens de la même
façon, `.bashrc` et `.bash_profile`, que son `find` ne peut pas atteindre.

shellcheck, shfmt et yamllint sont installés par `mise-action`, qui lit le
`.config/mise/config.toml` de ce dépôt. Le local et la CI lintent donc avec les
mêmes versions ([outils.md](outils.md)).

Les Actions sont épinglées sur des SHA de commit complets : un tag peut être
repointé vers un commit malveillant, un SHA non. `permissions: contents: read`
limite le token à ce dont un linter a besoin. Dependabot propose les montées
chaque semaine.

</details>

---

Voir aussi : [installer.md](installer.md) pour ce qui change une machine, et
[security.md](security.md) pour les clés et les planchers de version.
