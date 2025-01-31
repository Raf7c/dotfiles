Traduction : [🇫🇷 ](./README_fr.md) or [ 🇺🇸 ](../../README.md)
# dotfiles
> [!NOTE] Ceci est écrit plus  comme un rappel pour moi-même que pour vous
## Table des matières
- [Points forts des fonctionnalités](#points-forts-des-fonctionnalités)
- [Feuille de route des TODO](../TODO.md)
- [Exigences](#exigences)
- [Structure](#structure)
- [Démarrer](#comment-démarrer)
- [Outils et applications que j'utilise](#outils-et-applications-que-jutilise)

## Points forts des fonctionnalités
- Configurations multi-hôtes et multi-utilisateurs basées sur Flake Darwin et Home-Manager.
    - Les configurations de base pour les hôtes et les utilisateurs gèrent de manière dynamique les spécifications d'hôte basées sur Darwin.
    - Configurations facultatives pour les besoins spécifiques de l'utilisateur et de l'hôte.
    - submodule conf-nvim.
    
La feuille de route des fonctionnalités supplémentaires est répartie  sur des objectifs à court terme, dans la [Feuille de route des TODO](../TODO.md).

Les fonctionnalités terminées seront ajoutées ici au fur et à mesure que chaque étape sera terminée.

## Exigences
- _MacOS =>_ `15.2`
- _Nix =>_ `2.25.4`
- _`Homebrew`_

Il s'agit d'une configuration personnalisée qui nécessite plusieurs prérequis techniques pour être construite avec succès. Cette configuration nix vous servira au mieux de référence, de ressource d'apprentissage et de modèle pour créer votre propre configuration.

## Structure
Pour plus de détails sur les concepts de conception:
- `flake.nix` - Point d'entrée pour les configurations d'hôtes et d'utilisateurs.
- `hosts` - Configurations NixOS accessibles via `darwin-rebuild switch --flake .#<host>`.
  - `common` - Configurations partagées consommées par les machines spécifiques.
    - `core` - Configurations présentes sur tous les hôtes. C'est une règle stricte ! Si quelque chose n'est pas essentiel, c'est facultatif.
    - `optional` - Configurations facultatives présentes sur plusieurs hôtes.
- `dev-lab` - MacSutudio
- `dev-lab-bis` - MacbookPro
- `home/<user>` - Configurations du home-manager, construites automatiquement lors des reconstructions de l'hôte.
  - `common` - Les configurations partagées du home-manager consommaient celles spécifiques à la machine de l'utilisateur.
    - `core` - Configurations du home-manager présentes pour l'utilisateur sur toutes les machines. C'est une règle stricte ! Si quelque chose n'est pas essentiel, c'est facultatif.
    - `optional` - Configurations du home-manager facultatives qui peuvent être ajoutées pour des machines spécifiques.
- `lib` - Bibliothèque personnalisée utilisée dans nix-config pour rendre les chemins d'importation plus lisibles. Accessible via `lib.custom`.
- `modules` - Modules personnalisés pour activer des fonctionnalités et des options spéciales.
    - `darwin` - Modules personnalisés spécifiques aux hôtes basés sur dariwn
- `scripts` - Scripts personnalisés pour l'automatisation.

## Comment démarrer
Exécuter :
Download configuration
``` shell
$ nix-shell -p git --run 'git clone https://github.com/Raf7c/dotfiles.git .dotfiles'
```

Install
``` shell
$ nix run nix-darwin --extra-experimental-features "nix-command flakes" -- switch --flake .#raf-devlab --impure
```
`.#raf-devla`or `.#raf-devlab-bis`

`darwin-rebuild --flake .#<host>`Pour construire des configurations de système.</br>
`home-manager --flake .#<host>`Pour créer des configurations utilisateur.</br>
`nix build`(ou shell ou exécuter) Pour créer et utiliser des packages.</br>


Éviter les erreurs liées aux dépendances manquantes :
``` shell
git submodule update --init --recursive
```

## Outils et applications que j'utilise
