{ config, pkgs, lib, ... }:
{
  imports = [
    ./sops.nix
  ];

  # Allow non-free packages
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
    asdf-vm
    lazygit
    lazydocker
  ];

  homebrew = {
    taps = [ ];
    brews = ["mas" "xz" "zlib" "openssl" "readline"];
    casks = ["arc" "raycast" "cleanmymac" "discord" "obsidian" "notion" "slack" "figma"];
    masApps = { "ZSA Keymapp" = 6472865291; };
  };

  # All nerd-fonts
  fonts.packages = builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
  programs.zsh.enable = true;
  environment.shells = with pkgs; [ zsh ];
}