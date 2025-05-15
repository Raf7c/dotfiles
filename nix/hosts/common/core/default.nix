{ config, pkgs, lib, ... }:
{
  imports = [
    ./sops.nix
    ./nix.nix
  ];

  # Packages système de base
  environment.systemPackages = with pkgs; [
    # App
    kitty
    vscode
    obsidian
    slack
    raycast
    arc-browser
    discord
    gitkraken
    
    # CLI tool
    curl
    wget
    gnupg
    git
    gh
    tree
    eza
    fd
    ripgrep
    jq
    lazygit
    lazydocker
  ];

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap"; # Nettoie les packages non déclarés
      upgrade = true;
    };
    taps = [ ];
    brews = ["mas" "xz" "zlib" "openssl" "readline"];
    casks = [ "cleanmymac" "notion" "notion-calendar" "figma" "docker" "istat-menus" "ledger-live" "cursor"];
    masApps = { "ZSA Keymapp" = 6472865291; };
  };
  
  # All nerd-fonts
  fonts.packages = builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
  programs.zsh.enable = true;
  environment.shells = with pkgs; [ zsh ];
}