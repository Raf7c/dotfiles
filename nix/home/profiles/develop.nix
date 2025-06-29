{ config, pkgs, lib, isLaptop, sharedEnv, ... }:
let
  # Use relative paths instead of absolute paths
  dotfilesDir = builtins.toString ../../../.;
  
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
    ../common/core/tools/tmux.nix
  ];

  # Configuration files for development
  xdg.configFile = {
    "prettier/.prettierrc.json".source = "${dotfilesDir}/nix/home/common/core/tools/config/formatting-config/.prettierrc.json";
    "eslint/.eslintrc.json".source = "${dotfilesDir}/nix/home/common/core/tools/config/linting-config/.eslintrc.json";
    "stylelint/.stylelintrc.json".source = "${dotfilesDir}/nix/home/common/core/tools/config/stylelint-config/.stylelintrc.json";
  };

  home.file = {
    ".zshrc" = {
      source = "${dotfilesDir}/nix/home/common/core/shell/.zshrc";
      target = "${config.home.homeDirectory}/.zshrc";
    };
    ".tool-versions" = {
      source = "${dotfilesDir}/nix/home/common/core/development/.tool-versions";
      target = "${config.home.homeDirectory}/.tool-versions";
    };
  };
  
  # Development terminal configuration
  programs.kitty = import ../common/core/terminal/kitty.nix {
    inherit config pkgs isLaptop;
    fontSize = fontSize;
    fontFamily = sharedEnv.fontFamily;
  };
} 