{ config, lib, pkgs, ... }:

{
  home.stateVersion = "23.11";

  programs.git = {
    enable = true;
    userName = "Raf7c";
    userEmail = "122828688+Raf7c@users.noreply.github.com";
  };
}