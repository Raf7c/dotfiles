{ config, pkgs, lib, ... }:

{
  imports = [
    ./sops.nix
  ];

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    curl
    kitty
    wget
    gnupg
    git
    gh
    tree
    tmux
    vscode
    eza
    fd
    ripgrep
    xz
    asdf-vm
  ];

  homebrew = {
    taps = [ ];
    brews = ["mas"];
    casks = ["arc" "raycast" "cleanmymac" "discord" "obsidian"];
    masApps = { "ZSA Keymapp" = 6472865291; };
  };

  fonts.packages = builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
  programs.zsh.enable = true;
  environment.shells = with pkgs; [ zsh ];
}