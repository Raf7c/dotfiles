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
      ProgramArguments = [ "/etc/profiles/per-user/${config.home.username}/bin/theme-switcher" "watch" ];
      KeepAlive = true;
      RunAtLoad = true;
      StandardOutPath = "${config.home.homeDirectory}/.local/share/theme-switcher.log";
      StandardErrorPath = "${config.home.homeDirectory}/.local/share/theme-switcher.error.log";
      ProcessType = "Background";
      EnvironmentVariables = {
        HOME = config.home.homeDirectory;
        PATH = "/etc/profiles/per-user/${config.home.username}/bin:/usr/bin:/bin";
      };
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