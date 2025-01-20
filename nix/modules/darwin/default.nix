{ config, pkgs, self, ... }:

{
  # service nix-daemon
  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;
  system.stateVersion = 4;
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    substituters = [ "https://cache.nixos.org/" ];
  };
  system.configurationRevision = self.rev or self.dirtyRev or null;

  # TouchID
  security.pam.enableSudoTouchIdAuth = true;

  # Setup Homebrew
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
    };
    global = {
      brewfile = true;
      lockfiles = false;
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