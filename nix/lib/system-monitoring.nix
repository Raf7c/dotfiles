{ pkgs, lib, config, ... }:

let
  # Centralized theme configuration
  themeConfig = {
    # Theme directory
    dir = "$HOME/.dotfiles/nix/theme";
    
    # Kitty themes
    kitty = {
      light = "catppuccin/kitty/catppuccin_latte";
      dark = "catppuccin/kitty/catppuccin_mocha";
    };
    
    # Bat themes
    bat = {
      light = "Catppuccin-latte";
      dark = "Catppuccin-mocha";
    };
    
    # Detection speed (in seconds)
    checkInterval = 0.5;
  };

  # Simplified theme management script
  themeScript = pkgs.writeShellScriptBin "theme-switcher" ''
    #!/bin/bash
    set -euo pipefail
    
    # === UTILITIES ===
    is_dark_mode() { 
      [[ "$(defaults read -g AppleInterfaceStyle 2>/dev/null)" == "Dark" ]]
    }
    
    log() { 
      echo "$(date '+%H:%M:%S') $*" 
    }
    
    # === BAT CONFIGURATION ===
    setup_bat() {
      local theme="$1"
      local bat_theme
      
      case "$theme" in
        light) bat_theme="${themeConfig.bat.light}" ;;
        dark)  bat_theme="${themeConfig.bat.dark}" ;;
        *)     bat_theme="${themeConfig.bat.dark}" ;;
      esac
      
      mkdir -p "$HOME/.local/share"
      cat > "$HOME/.local/share/bat-config-dynamic" << EOF
# Automatic bat configuration - $(date)
--theme="$bat_theme"
--italic-text=always
--style="numbers,changes,header"
--pager="less -FR"
EOF
      log "🦇 Bat: $bat_theme"
    }
    
    # === KITTY CONFIGURATION ===
    setup_kitty() {
      local theme="$1"
      local kitty_theme
      
      case "$theme" in
        light) kitty_theme="${themeConfig.kitty.light}" ;;
        dark)  kitty_theme="${themeConfig.kitty.dark}" ;;
        *)     kitty_theme="${themeConfig.kitty.dark}" ;;
      esac
      
      # Symbolic link for Kitty
      mkdir -p "$HOME/.config/nix-themes"
      ln -sf "${themeConfig.dir}/$kitty_theme.conf" "$HOME/.config/nix-themes/current.conf"
      
      # Reload Kitty if possible
      pkill -USR1 kitty 2>/dev/null || true
      
      log "🐱 Kitty: $kitty_theme"
    }
    
    # === THEME APPLICATION ===
    apply_theme() {
      local mode="$1"
      
      # Automatic detection if needed
      if [[ "$mode" == "auto" ]]; then
        mode=$(is_dark_mode && echo "dark" || echo "light")
      fi
      
      # Mode validation
      case "$mode" in
        light|dark) ;;
        *) echo "Usage: theme-switcher {light|dark|auto|watch|status}"; exit 1 ;;
      esac
      
      # Save state
      echo "$mode" > "$HOME/.local/share/current-theme"
      
      # Apply themes
      setup_kitty "$mode"
      setup_bat "$mode"
      
      log "✅ $mode theme applied"
    }
    
    # === AUTOMATIC MONITORING ===
    watch_changes() {
      log "🔄 Automatic monitoring enabled (checking every ${toString themeConfig.checkInterval}s)"
      current=""
      
      while true; do
        new=$(is_dark_mode && echo "dark" || echo "light")
        if [[ "$new" != "$current" ]]; then
          current="$new"
          apply_theme "$new"
          log "🌓 Change detected: $current"
        fi
        sleep ${toString themeConfig.checkInterval}
      done
    }
    
    # === STATUS ===
    show_status() {
      echo "🌓 System mode: $(is_dark_mode && echo "dark" || echo "light")"
      
      if [[ -f "$HOME/.local/share/current-theme" ]]; then
        echo "🎨 Current theme: $(cat "$HOME/.local/share/current-theme")"
      fi
      
      if [[ -f "$HOME/.config/nix-themes/current.conf" ]]; then
        echo "🔗 Kitty: $(basename "$(readlink "$HOME/.config/nix-themes/current.conf")" .conf)"
      fi
      
      if [[ -f "$HOME/.local/share/bat-config-dynamic" ]]; then
        echo "🦇 Bat: $(grep -- --theme "$HOME/.local/share/bat-config-dynamic" | cut -d'"' -f2)"
      fi
    }
    
    # === COMMANDS ===
    case "''${1:-}" in
      watch)  watch_changes ;;
      status) show_status ;;
      *)      apply_theme "$1" ;;
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