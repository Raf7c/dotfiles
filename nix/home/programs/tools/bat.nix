{ config, lib, pkgs, ... }:

{
  programs.bat = {
    enable = true;

    themes = {
      "Catppuccin-mocha" = {
        src = pkgs.fetchFromGitHub {
          owner = "catppuccin";
          repo = "bat";
          rev = "ba4d16880d63e656acced2b7d4e034e4a93f74b1";
          sha256 = "sha256-6WVKQErGdaqb++oaXnY3i6/GuH2FhTgK0v4TN4Y0Wbw=";
        };
        file = "Catppuccin-mocha.tmTheme";
      };
    };
  };
  
  # Script bat avec thème automatique
  home.packages = [ 
    (pkgs.writeShellScriptBin "bat-dynamic" ''
      config_file="$HOME/.local/share/bat-config-dynamic"
      if [[ -f "$config_file" ]]; then
        exec bat --config-file "$config_file" "$@"
      else
        exec bat "$@"
      fi
    '')
  ];
} 