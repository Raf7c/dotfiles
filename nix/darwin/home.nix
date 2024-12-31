{ config, lib, pkgs, ... }:

{
  home.username = "raf";
  home.homeDirectory = "/Users/raf";
  home.stateVersion = "23.11";
  programs.home-manager.enable = true;
  xdg.enable = true;

  home.file = {
    ".config/kitty".source = "${config.home.homeDirectory}/dotfiles/kitty";
  };

  programs = {
    zsh = import ../home/zsh.nix {inherit config pkgs lib; };
    git = import ../home/git.nix {inherit config pkgs; };
    starship = import ../home/starship.nix { inherit pkgs; };
    fzf = import "${config.home.homeDirectory}/dotfiles/nix/home/fzf.nix" { inherit pkgs; };
    bat = import "${config.home.homeDirectory}/dotfiles/nix/home/bat.nix" { inherit config lib pkgs; };
  };
}