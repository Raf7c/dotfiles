{ pkgs, lib, config, ... }:

let
  # Centralized configuration
  cfg = {
    themeDir = "$HOME/.dotfiles/nix/theme";
    themes = {
      light = "gruvbox_light";
      dark = "catppuccin_mocha";
    };
  };
  
  # Theme management script with Home Manager
  themeScript = pkgs.writeShellScriptBin "theme-switcher" ''
    #!/bin/bash
    set -euo pipefail
    
    is_dark_mode() { [[ "$(defaults read -g AppleInterfaceStyle 2>/dev/null)" == "Dark" ]]; }
    log() { echo "$(date '+%H:%M:%S') $*"; }
    
    apply_theme() {
      local theme="$1" theme_name
      
      case "$theme" in
        light) theme_name="${cfg.themes.light}" ;;
        dark) theme_name="${cfg.themes.dark}" ;;
        auto) 
          if is_dark_mode; then
            theme="dark"; theme_name="${cfg.themes.dark}"
          else  
            theme="light"; theme_name="${cfg.themes.light}"
          fi ;;
        *) echo "Usage: theme-switcher {light|dark|auto|watch|status}"; exit 1 ;;
      esac
      
      # Save current theme
      echo "$theme" > "$HOME/.local/share/current-theme"
      echo "$theme_name" > "$HOME/.local/share/current-theme-name"
      
      # Create symbolic link to current theme for Home Manager
      mkdir -p "$HOME/.config/nix-themes"
      ln -sf "${cfg.themeDir}/$theme_name.conf" "$HOME/.config/nix-themes/current.conf"
      
      # Reload Kitty if it exists
      if command -v kitty >/dev/null 2>&1; then
        pkill -USR1 kitty 2>/dev/null || true
        kitty @ load-config 2>/dev/null || true
      fi
      
      log "✅ Theme $theme applied ($theme_name)"
    }
    
    case "''${1:-}" in
      watch)
        log "🔄 Automatic monitoring enabled"
        current=""
        while true; do
          new=$(is_dark_mode && echo "dark" || echo "light")
          [[ "$new" != "$current" ]] && { current="$new"; apply_theme "auto"; log "🌓 Change: $current"; }
          sleep 5
        done ;;
      status)
        echo "🌓 System mode: $(is_dark_mode && echo "dark" || echo "light")"
        [[ -f "$HOME/.local/share/current-theme" ]] && echo "🎨 Theme: $(cat "$HOME/.local/share/current-theme")"
        [[ -f "$HOME/.local/share/current-theme-name" ]] && echo "📋 File: $(cat "$HOME/.local/share/current-theme-name").conf"
        [[ -f "$HOME/.config/nix-themes/current.conf" ]] && echo "🔗 Link: $(readlink "$HOME/.config/nix-themes/current.conf")" ;;
      *) apply_theme "$1" ;;
    esac
  '';

in {
  systemMonitoring = {
    packages = with pkgs; [ btop htop themeScript ];
    
    aliases = {
      monitor = "btop";
      sys = "btop"; 
      theme-status = "theme-switcher status";
    };
    
    btopConfig = {
      color_theme = "auto";
      theme_background = true;
      truecolor = true;
      vim_keys = true;
      rounded_corners = true;
      graph_symbol = "braille";
      shown_boxes = "cpu mem net proc";
      update_ms = 2000;
    };
  };
} 