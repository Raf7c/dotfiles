{ config, pkgs, ... }:

{
  # Productivity tools
  environment.systemPackages = with pkgs; [
    obsidian
    slack
    raycast
  ];
} 