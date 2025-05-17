{ config, pkgs, ... }:

{
  # Base system packages
  environment.systemPackages = with pkgs; [
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