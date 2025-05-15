{ config, pkgs, lib, hostname, isLaptop, sharedEnv, ... }:
let
  # Utiliser des chemins relatifs plutôt que des chemins absolus
  dotfilesDir = builtins.toString ../../.;
  
  # Fonction pour créer des liens symboliques de manière plus robuste
  mkConfigFile = file: source: {
    "${file}".source = "${dotfilesDir}/nix/home/common/core/${source}";
  };
  
  # Taille de police basée sur le type de machine
  fontSize = if isLaptop 
    then sharedEnv.fontSize.laptop 
    else sharedEnv.fontSize.desktop;
in 

{
  home.stateVersion = "23.11";
  programs.home-manager.enable = true;
  home.homeDirectory = "/Users/raf";
  home.username = "raf";

  # Utiliser une approche plus robuste pour les fichiers de configuration
  home.file = lib.mkMerge [
    (mkConfigFile ".zshrc" ".zshrc")
    (mkConfigFile ".tool-versions" ".tool-versions")
    (mkConfigFile ".prettierrc.json" "formatting-config/.prettierrc.json")
    (mkConfigFile ".eslintrc.json" "linting-config/.eslintrc.json")
    (mkConfigFile "Library/Application Support/Code/User/settings.json" "vscode/settings.json")
    (mkConfigFile "Library/Application Support/Code/User/keybindings.json" "vscode/keybindings.json")
  ];

  imports = [
    ./common/core/asdf.nix
    ./common/core/nvim.nix
    # Import nvim directly
  ];

  programs = {
    git = import ./common/core/git.nix {inherit config pkgs; };
    starship = import ./common/core/starship.nix { inherit pkgs; };
    fzf = import ./common/core/fzf.nix { inherit pkgs; };
    kitty = import ./common/core/kitty.nix {
      inherit config pkgs isLaptop;
      fontSize = fontSize;
      fontFamily = sharedEnv.fontFamily;
      theme = sharedEnv.theme;
    };
  };
}