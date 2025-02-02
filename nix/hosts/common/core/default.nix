{ config, pkgs, lib, ... }:
{
  imports = [
    ./sops.nix
  ];

  # Allow non-free packages
  nixpkgs.config.allowUnfree = true;
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
    tmux
    eza
    fd
    ripgrep
    lazygit
    lazydocker
  ];

  homebrew = {
    taps = [ ];
    brews = ["mas" "xz" "zlib" "openssl" "readline"];
    casks = [ "cleanmymac" "notion" "notion-calendar" "figma" "docker" "istat-menus" "ledger-live"];
    masApps = { "ZSA Keymapp" = 6472865291; };
  };

  # All nerd-fonts
  fonts.packages = builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
  programs.zsh.enable = true;
  environment.shells = with pkgs; [ zsh ];
}