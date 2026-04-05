Configuration personnelle pour **macOS** (Apple Silicon).

## Prérequis

- Mac **Apple Silicon** (M1, M2, M3, …)
- **macOS** récent (testé avec Tahoe 26+ ; versions antérieures peuvent fonctionner)
- **Xcode Command Line Tools** : `xcode-select --install`
- **Git** (souvent fourni avec les outils Xcode)

## Installation

```sh
git clone <url-du-depot> ~/.dotfiles
cd ~/.dotfiles
chmod +x dot.sh
./dot.sh
```

Exécute `./dot.sh` depuis la racine du dépôt (ou avec le chemin absolu vers `dot.sh`).

## Utilisation

Lance **`./dot.sh`** sans argument : synchronisation complète (voir ci-dessous). Tout argument est refusé.

Si la sortie standard est un **terminal interactif**, le script termine par un **`exec` d’un shell de login** (`$SHELL -l`) pour prendre en compte tout de suite les nouveaux liens et le `PATH` (par exemple après Homebrew).

## Ce que fait `./dot.sh`



## Shell

- **zsh :** 
- **bash :**
- **bash :** 

## Tmux



## Licence

Voir le fichier `LICENSE` à la racine du dépôt.
