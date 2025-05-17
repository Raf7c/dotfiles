{ config, pkgs, lib, ... }:

let
  vscodeConfigPath = ../../../config/vscode;
  localVscodeConfigPath = ./vscode;
in
{
  xdg.configFile = {
    "Code/User/settings.json" = {
      source = config.lib.file.mkOutOfStoreSymlink "${localVscodeConfigPath}/settings.json";
    };
    "Code/User/keybindings.json" = {
      source = config.lib.file.mkOutOfStoreSymlink "${localVscodeConfigPath}/keybindings.json";
    };
  };
} 