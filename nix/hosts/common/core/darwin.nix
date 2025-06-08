{ config, pkgs, lib, ... }:

{
  # Nix configuration
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];

    };
    
    # Automatic garbage collection
    gc = {
      automatic = true;
      interval = { Day = 2; Hour = 20; Minute = 30; };
      options = "--delete-older-than 7d";
    };
    
    # Store optimization
    optimise = {
      automatic = true;
      interval = { Day = 2; Hour = 20; Minute = 30; };
    };
  };
  
  # Allow non-free packages
  nixpkgs.config.allowUnfree = true;

  # Activation script to clean up unused packages
  system.activationScripts.extraActivation.text = ''
    echo "Cleaning up unused packages..."
    /run/current-system/sw/bin/nix-collect-garbage --delete-old > /dev/null 2>&1 || true
  '';

  # Shell Configuration
  programs.zsh.enable = true;
  environment.shells = with pkgs; [ zsh ];
} 