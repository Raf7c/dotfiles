{ config, pkgs, lib, ... }:

{
  home.stateVersion = "23.11";
  programs.home-manager.enable = true;
  home.homeDirectory = "/Users/raf";
  home.username = "raf";

  programs = {
    zsh = import ../home/common/core/zsh.nix { inherit config pkgs lib; };
  };
}