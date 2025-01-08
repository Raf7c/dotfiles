{ config, pkgs, ... }:

{
  imports = [
    ./sops.nix
  ];


  environment.systemPackages = with pkgs; [
    curl
    wget
  ];


  programs.zsh.enable = true;
    # Configuration du shell
  environment.shells = with pkgs; [ zsh ];
}