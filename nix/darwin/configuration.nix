{ config, lib, pkgs, self, ... }:
{
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    alacritty
    neovim
    vscode
    git
    gh
    curl
    tree
    tmux
    eza
    fd
    ripgrep
  ];
  homebrew = {
    enable = true;
    brews = ["mas"];
    casks = ["arc" "firefox" "raycast" "cleanmymac" "discord" "obsidian" "kitty"];
    masApps = { "ZSA Keymapp" = 6472865291; };
    onActivation.cleanup = "zap";
  };

  users.users.raf.home = "/Users/raf";
  nix.settings.experimental-features = "nix-command flakes";
  programs.zsh.enable = true;
  system.configurationRevision = self.rev or self.dirtyRev or null;
  system.stateVersion = 5;
  nixpkgs.hostPlatform = "aarch64-darwin";
  security.pam.enableSudoTouchIdAuth = true;

  fonts.packages = builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
  
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
    };
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