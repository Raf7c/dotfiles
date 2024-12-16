{ config, pkgs, lib, ... }:

{
  home.username = "raf";
  home.homeDirectory = /Users/raf;
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
  ];
  home.file = {
    ".gitconfig".source = "/Users/raf/dotfiles/gitconfig";
    #".zshrc".source = "/Users/raf/dotfiles/zshrc";
  };

  home.sessionPath = [
    "/run/current-system/sw/bin"
      "$HOME/.nix-profile/bin"
  ];

  programs = {
    zsh = import /Users/raf/dotfiles/nix/home/zsh.nix {inherit config pkgs lib; };
  };
}