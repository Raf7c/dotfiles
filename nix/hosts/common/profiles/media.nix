{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    arc-browser
    spotify
    discord

  ];
} 