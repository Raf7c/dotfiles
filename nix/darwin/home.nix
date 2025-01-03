{ config, lib, pkgs, configDir, ... }:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;
in 

{
  home.username = "raf";
  home.homeDirectory = "/Users/raf";
  home.stateVersion = "23.11";
  programs.home-manager.enable = true;
  xdg.enable = true;

  home.file = {
    ".tool-versions".source = mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.tool-versions";
  };

  xdg.configFile = {
    "kitty".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.config/kitty";
    "nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.config/nvim";
  };
   




  programs = {
    zsh = import ../home/zsh.nix {inherit config pkgs lib; };
    git = import ../home/git.nix {inherit config pkgs; };
    starship = import ../home/starship.nix { inherit pkgs; };
    fzf = import ../home/fzf.nix { inherit pkgs; };
    bat = import ../home/bat.nix { inherit config lib pkgs; };
  };
  

}