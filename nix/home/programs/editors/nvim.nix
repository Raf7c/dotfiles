{ config, pkgs, lib, ... }:

let
  nvimConfigPath = ../../../config/nvim;
in
{
  home.file = {
    ".config/nvim" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/nix/config/nvim";
      recursive = true;
    };
  };
} 