{ config, pkgs, lib, ... }:

let
  vscodeConfigPath = ../../../config/vscode;
  localVscodeConfigPath = ./vscode;
in
{
  home.file = {
    "Library/Application Support/Code/User/settings.json" = {
      source = config.lib.file.mkOutOfStoreSymlink "${localVscodeConfigPath}/settings.json";
    };
    "Library/Application Support/Code/User/keybindings.json" = {
      source = config.lib.file.mkOutOfStoreSymlink "${localVscodeConfigPath}/keybindings.json";
    };
  };
} 