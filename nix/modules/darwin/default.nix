{ config, pkgs, ... }:

{
  # Configuration de base de Darwin
  system.defaults.dock.autohide = true;
  system.defaults.finder.AppleShowAllExtensions = true;


  # Activation de certains services
  services.nix-daemon.enable = true;

  # Configuration de Nix
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    substituters = [ "https://cache.nixos.org/" ];
  };
  nix.package = pkgs.nix;

  # Assurez-vous que le système est à jour
  system.stateVersion = 4;

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



}