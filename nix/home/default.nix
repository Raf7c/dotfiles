{ config, pkgs, lib, ... }:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;
in 

{
  home.stateVersion = "23.11";
  programs.home-manager.enable = true;
  home.homeDirectory = "/Users/raf";
  home.username = "raf";

  home.file = {
    # asdf
    ".tool-versions".source = mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/nix//home/common/core/.tool-versions";
  };

  imports = [
    ./common/core/nvim.nix
    # Import nvim directly
  ];

  programs = {
    zsh = import ../home/common/core/zsh.nix { inherit config pkgs lib; };
    git = import ../home/common/core/git.nix {inherit config pkgs; };
    bat = import ../home/common/core/bat.nix { inherit config lib pkgs; };
    starship = import ../home/common/core/starship.nix { inherit pkgs; };
    fzf = import ../home/common/core/fzf.nix { inherit pkgs; };
    kitty = import ../home/common/core/kitty.nix {inherit config pkgs; };
  };
}