{ config, pkgs, lib, isLaptop, sharedEnv, ... }:
let
  # Use relative paths instead of absolute paths
  dotfilesDir = builtins.toString ../../../.;
  
  # Function to create symbolic links more robustly
  mkConfigFile = file: source: program: {
    "${file}".source = "${dotfilesDir}/nix/home/programs/${program}/${source}";
  };
  
  # Font size based on machine type
  fontSize = if isLaptop 
    then sharedEnv.fontSize.laptop 
    else sharedEnv.fontSize.desktop;
in
{
  imports = [
    # Editors and development tools
    ../programs/editors/nvim.nix
    ../programs/editors/vscode.nix
    ../programs/development/asdf.nix
    ../programs/tools/git.nix
    ../programs/tools/fzf.nix
    ../programs/tools/bat.nix
    ../programs/tools/monitoring.nix
    ../programs/shell/starship.nix
  ];

  # Configuration files for development
  home.file = lib.mkMerge [
    (mkConfigFile ".zshrc" ".zshrc" "shell")
    (mkConfigFile ".tool-versions" ".tool-versions" "development")
    (mkConfigFile ".prettierrc.json" "config/formatting-config/.prettierrc.json" "tools")
    (mkConfigFile ".eslintrc.json" "config/linting-config/.eslintrc.json" "tools")
    (mkConfigFile ".stylelintrc.json" "config/stylelint-config/.stylelintrc.json" "tools")
  ];
  
  # Development terminal configuration
  programs.kitty = import ../programs/terminal/kitty.nix {
    inherit config pkgs isLaptop;
    fontSize = fontSize;
    fontFamily = sharedEnv.fontFamily;
  };
} 