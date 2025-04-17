{ config, pkgs, self, ... }:

{
  # service nix-daemon (maj d'api)
  nix.enable = true;
  nix.package = pkgs.nix;
  system.stateVersion = 4;
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    substituters = [ "https://cache.nixos.org/" ];
  };
  system.configurationRevision = self.rev or self.dirtyRev or null;

  # Résoudre le problème de GID pour les utilisateurs nixbld
  ids.gids.nixbld = 350;

  # TouchID (maj d'api)
  security.pam.services.sudo_local.touchIdAuth = true;

  # Setup Homebrew
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
    };
    global = {
      brewfile = true;
    };
  };

  # macOS system preferences
  system.defaults = {
    dock = {
      autohide = true;
      autohide-time-modifier = 0.1;
      autohide-delay = 0.0;
      mru-spaces = false;
      show-recents = false;
    };
    finder = {
      FXPreferredViewStyle = "clmv";
      AppleShowAllFiles = true;
      AppleShowAllExtensions = true;
    };
    # Overall system configuration
    NSGlobalDomain = {
      AppleICUForce24HourTime = true;
      AppleShowAllExtensions = true;
      NSAutomaticSpellingCorrectionEnabled = false;
    };
    screencapture = {
      location = "~/Pictures/screenshots";
      type = "png";
    };
    screensaver = {
      askForPassword = true;
      askForPasswordDelay = 10;
    };
  };
}