{ config, pkgs, self, ... }:

{
  # System configuration
  system.stateVersion = 4;
  system.configurationRevision = self.rev or self.dirtyRev or null;

  # Fix GID issue for nixbld users
  ids.gids.nixbld = 350;

  # TouchID
  security.pam.services.sudo_local.touchIdAuth = true;

  # macOS system preferences
  system.defaults = {
    dock = {
      magnification = true;
      largesize = 69;
      
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