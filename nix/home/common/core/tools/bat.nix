{ config, lib, pkgs, ... }:

{
  programs.bat = {
    enable = true;

    # === LOCAL CATPPUCCIN THEMES ===
    # Required for Nix to install the themes
    themes = {
      "Catppuccin-mocha" = {
        src = ../../../../theme/catppuccin/bat;
        file = "catppuccin_mocha.tmTheme";
      };
      
      "Catppuccin-latte" = {
        src = ../../../../theme/catppuccin/bat;
        file = "catppuccin_latte.tmTheme";
      };
    };
    
    # Configuration managed automatically by system-monitoring.nix
  };
  
  # === DYNAMIC BAT SCRIPT ===
  # Uses automatic configuration when available
  home.packages = [ 
    (pkgs.writeShellScriptBin "bat-auto" ''
      config_file="$HOME/.local/share/bat-config-dynamic"
      if [[ -f "$config_file" ]]; then
        exec bat --config-file "$config_file" "$@"
      else
        exec bat "$@"
      fi
    '')
  ];
} 