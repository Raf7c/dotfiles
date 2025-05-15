{ config, pkgs, lib, ... }:

{
  # Configuration Nix
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
    };
    
    # Garbage collection automatique
    gc = {
      automatic = true;
      interval = { Day = 2; Hour = 20; Minute = 30; };
      options = "--delete-older-than 5d";
    };
    
    # Optimisation du store
    optimise = {
      automatic = true;
      interval = { Day = 2; Hour = 20; Minute = 30; };
    };
  };
  
  # Allow non-free packages
  nixpkgs.config.allowUnfree = true;

  # Script d'activation pour nettoyer les packages non utilisés
  system.activationScripts.extraActivation.text = ''
    echo "Nettoyage des packages non utilisés..."
    /run/current-system/sw/bin/nix-collect-garbage --delete-old > /dev/null 2>&1 || true
  '';
} 