# home-manager switch 
{ config, pkgs, ... }:

{
  home.username = "raf";
  home.homeDirectory = "/Users/raf";
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;
  xdg.enable = true;

  home.packages = with pkgs; [
    # Packages de base
    pkgs.wget
    pkgs.curl
    pkgs.htop
    pkgs.tree
  ];
  
  programs.zsh.enable = true;
}