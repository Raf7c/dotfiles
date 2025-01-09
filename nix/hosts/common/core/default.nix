{ config, pkgs, ... }:

{
  imports = [
    ./sops.nix
  ];

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    curl
    wget
    gnupg
    git
    gh
    tree
    tmux
    vscode
  ];


  programs.zsh.enable = true;
    # Configuration du shell
  environment.shells = with pkgs; [ zsh ];

  homebrew = {
    taps = [ ];
    brews = ["mas"];
    casks = ["arc" "raycast" "cleanmymac" "discord" "obsidian"];
  };
}