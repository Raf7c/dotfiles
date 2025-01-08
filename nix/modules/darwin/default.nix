{ config, pkgs, ... }:

{
  # Configuration de base de Darwin
  system.defaults.dock.autohide = true;
  system.defaults.finder.AppleShowAllExtensions = true;

  # Logiciels installés au niveau du système
  environment.systemPackages = with pkgs; [
    curl
    wget
  ];

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

  # Configuration du shell
  programs.zsh.enable = true;
  environment.shells = with pkgs; [ zsh ];

}