{ config, pkgs, ... }:

{
  # Development packages
  environment.systemPackages = with pkgs; [
    vscode
    lazygit
    lazydocker
    glab
    gitkraken
    tmux
    kitty


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

  ];
} 