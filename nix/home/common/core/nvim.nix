{ config, pkgs, lib, ... }:

let
  nvimConfigPath = ../../../config/nvim;
in
{
  xdg.configFile = {
    "nvim" = {
      source = config.lib.file.mkOutOfStoreSymlink nvimConfigPath;
      recursive = true;
    };
  };
}