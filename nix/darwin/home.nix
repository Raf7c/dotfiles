{ config, lib, pkgs, ... }:

{
  home.username = "raf";
  home.homeDirectory = "/Users/raf";
  home.stateVersion = "23.11";
  programs.home-manager.enable = true;
  xdg.enable = true;

  programs = {
    zsh = import ../home/zsh.nix {inherit config pkgs lib; }; 
  };
}