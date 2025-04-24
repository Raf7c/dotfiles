{ config, pkgs, lib, ... }:

let
  vscodeConfigPath = ../../../config/vscode;
in
{
  xdg.configFile = {
    "Code/User" = {
      source = config.lib.file.mkOutOfStoreSymlink vscodeConfigPath;
      recursive = true;
    };
  };
} 