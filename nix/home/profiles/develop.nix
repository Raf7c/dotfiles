{ config, pkgs, lib, isLaptop, sharedEnv, ... }:
let
  # Use relative paths instead of absolute paths
  dotfilesDir = builtins.toString ../../../.;
  
  # Function to create symbolic links for core configuration files
  mkCoreConfigFile = file: source: program: {
    "${file}".source = "${dotfilesDir}/nix/home/common/core/${program}/${source}";
  };
  
  # Font size based on machine type
  fontSize = if isLaptop 
    then sharedEnv.fontSize.laptop 
    else sharedEnv.fontSize.desktop;
in
{
  imports = [
    # Editors and development tools
    ../common/core/editors/nvim.nix
    ../common/core/editors/vscode.nix
    ../common/core/development/asdf.nix
    ../common/core/tools/git.nix
    ../common/core/tools/fzf.nix
    ../common/core/tools/bat.nix
    ../common/core/tools/monitoring.nix
    ../common/core/shell/starship.nix
    ../common/core/tools/tmux/tmux.nix
  ];

  # Configuration files for development
  home.file = lib.mkMerge [
    (mkCoreConfigFile ".zshrc" ".zshrc" "shell")
    (mkCoreConfigFile ".tool-versions" ".tool-versions" "development")
    (mkCoreConfigFile ".prettierrc.json" "config/formatting-config/.prettierrc.json" "tools")
    (mkCoreConfigFile ".eslintrc.json" "config/linting-config/.eslintrc.json" "tools")
    (mkCoreConfigFile ".stylelintrc.json" "config/stylelint-config/.stylelintrc.json" "tools")
  ];
  
  # Development terminal configuration
  programs.kitty = import ../common/core/terminal/kitty.nix {
    inherit config pkgs isLaptop;
    fontSize = fontSize;
    fontFamily = sharedEnv.fontFamily;
  };
} 