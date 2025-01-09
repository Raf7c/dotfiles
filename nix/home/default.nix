{ config, pkgs, ... }:

{
  imports = [
    ./common/core/zsh.nix
  ];

  home.stateVersion = "23.11";
  programs.home-manager.enable = true;
  home.homeDirectory = "/Users/raf";
  home.username = "raf";

  home.packages = with pkgs; [
    # Ajoutez ici les paquets que vous voulez installer pour votre utilisateur
  ];
}