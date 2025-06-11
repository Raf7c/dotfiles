{ config, pkgs, lib, hostname, isLaptop, sharedEnv, ... }:

{
  home.stateVersion = "23.11";
  programs.home-manager.enable = true;
  home.homeDirectory = "/Users/raf";
  home.username = "raf";

  imports = [
    ./profiles/develop.nix
  ];

} 