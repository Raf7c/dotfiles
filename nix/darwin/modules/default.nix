{ config, pkgs, lib, ... }:
{
  imports = [
    ./sops.nix
    ./preferences.nix
    ../../common
  ];

  # macOS specific packages
  environment.systemPackages = with pkgs; [
    # App
    kitty
    obsidian
    slack
    raycast
  ];

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap"; # Clean up undeclared packages
      upgrade = true;
    };
    taps = [ ];
    brews = ["mas" "xz" "zlib" "openssl" "readline"];
    casks = [ "cleanmymac" "notion" "notion-calendar" "figma" "docker" "istat-menus" "ledger-live" "cursor"];
    masApps = { "ZSA Keymapp" = 6472865291; };
  };
  
  # Shell configuration
  programs.zsh.enable = true;
  environment.shells = with pkgs; [ zsh ];
}