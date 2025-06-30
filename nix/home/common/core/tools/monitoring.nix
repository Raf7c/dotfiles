{ config, pkgs, lib, ... }:

let
  monitoring = import ../../../../lib/system-monitoring.nix { inherit pkgs lib config; };
in
{
  # Base packages and configuration
  home.packages = monitoring.systemMonitoring.packages;
  home.shellAliases = monitoring.systemMonitoring.aliases;
  
  # Automatic theme switching service
  launchd.agents.theme-auto-switcher = {
    enable = true;
    config = {
      Label = "theme-auto-switcher";
      ProgramArguments = [ "${pkgs.bash}/bin/bash" "-c" ''
        # Attendre que le système soit complètement démarré
        sleep 5
        
        # Configurer l'environnement
        export PATH="/etc/profiles/per-user/${config.home.username}/bin:$PATH"
        export HOME="${config.home.homeDirectory}"
        
        # Démarrer le watcher
        exec theme-switcher watch
      '' ];
      KeepAlive = true;
      RunAtLoad = true;
      StandardOutPath = "${config.home.homeDirectory}/.local/share/theme-switcher.log";
      StandardErrorPath = "${config.home.homeDirectory}/.local/share/theme-switcher.error.log";
      ProcessType = "Background";
      ThrottleInterval = 30;
    };
  };
  
  # Initial theme activation
  home.activation.setupTheme = lib.hm.dag.entryAfter ["writeBoundary"] ''
    mkdir -p "$HOME/.local/share"
    
    if command -v theme-switcher >/dev/null 2>&1; then
      theme-switcher auto || true
    fi
  '';
} 