{ pkgs, lib, config, ... }:

let
  # Theme configuration
  themeConfig = {
    dir = "$HOME/.dotfiles/nix/theme";
    
    kitty = {
      light = "catppuccin/kitty/catppuccin_latte";
      dark = "catppuccin/kitty/catppuccin_mocha";
    };
    
    bat = {
      light = "Catppuccin-latte";
      dark = "Catppuccin-mocha";
    };
    
    checkInterval = 0.5;
  };

  # Theme management script
  themeScript = pkgs.writeShellScriptBin "theme-switcher" ''
    #!/bin/bash
    set -euo pipefail
    
    # Dark mode detection
    is_dark_mode() { 
      [[ "$(defaults read -g AppleInterfaceStyle 2>/dev/null)" == "Dark" ]]
    }
    
    # Bat configuration
    setup_bat() {
      local theme="$1"
      local bat_theme
      
      case "$theme" in
        light) bat_theme="${themeConfig.bat.light}" ;;
        dark)  bat_theme="${themeConfig.bat.dark}" ;;
      esac
      
      mkdir -p "$HOME/.local/share"
      echo "--theme=\"$bat_theme\"" > "$HOME/.local/share/bat-config-dynamic"
    }
    
    # Kitty configuration
    setup_kitty() {
      local theme="$1"
      local kitty_theme
      
      case "$theme" in
        light) kitty_theme="${themeConfig.kitty.light}" ;;
        dark)  kitty_theme="${themeConfig.kitty.dark}" ;;
      esac
      
      mkdir -p "$HOME/.config/nix-themes"
      ln -sf "${themeConfig.dir}/$kitty_theme.conf" "$HOME/.config/nix-themes/current.conf"
      pkill -USR1 kitty 2>/dev/null || true
    }
    
    # Theme application
    apply_theme() {
      local mode="$1"
      
      if [[ "$mode" == "auto" ]]; then
        mode=$(is_dark_mode && echo "dark" || echo "light")
      fi
      
      case "$mode" in
        light|dark) ;;
        *) echo "Usage: theme-switcher {light|dark|auto|watch|status}"; exit 1 ;;
      esac
      
      echo "$mode" > "$HOME/.local/share/current-theme"
      setup_kitty "$mode"
      setup_bat "$mode"
    }
    
    # Change monitoring
    watch_changes() {
      local current=""
      
      while true; do
        local new=$(is_dark_mode && echo "dark" || echo "light")
        if [[ "$new" != "$current" ]]; then
          current="$new"
          apply_theme "$new"
        fi
        sleep ${toString themeConfig.checkInterval}
      done
    }
    
    # Status display
    show_status() {
      echo "System mode: $(is_dark_mode && echo "dark" || echo "light")"
      
      if [[ -f "$HOME/.local/share/current-theme" ]]; then
        echo "Current theme: $(cat "$HOME/.local/share/current-theme")"
      fi
      
      if [[ -f "$HOME/.config/nix-themes/current.conf" ]]; then
        echo "Kitty: $(basename "$(readlink "$HOME/.config/nix-themes/current.conf")" .conf)"
      fi
      
      if [[ -f "$HOME/.local/share/bat-config-dynamic" ]]; then
        echo "Bat: $(grep -- --theme "$HOME/.local/share/bat-config-dynamic" | cut -d'"' -f2)"
      fi
    }
    
    # Main commands
    case "''${1:-}" in
      light)  apply_theme "light" ;;
      dark)   apply_theme "dark" ;;
      auto)   apply_theme "auto" ;;
      watch)  watch_changes ;;
      status) show_status ;;
      *)      echo "Usage: theme-switcher {light|dark|auto|watch|status}" ;;
    esac
  '';

in {
  systemMonitoring = {
    packages = with pkgs; [ themeScript ];
    
    aliases = {
      theme-status = "theme-switcher status";
    };
  };
} 