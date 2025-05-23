{ config, pkgs, lib, ... }:

{
  home.file = {
    "Library/Application Support/Code/User/settings.json" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/nix/home/common/core/vscode/settings.json";
      onChange = ''
        cp "$HOME/Library/Application Support/Code/User/settings.json" "${config.home.homeDirectory}/.dotfiles/nix/home/programs/editors/vscode/settings.json"
      '';
    };
    "Library/Application Support/Code/User/keybindings.json" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/nix/home/programs/editors/vscode/keybindings.json";
      onChange = ''
        cp "$HOME/Library/Application Support/Code/User/keybindings.json" "${config.home.homeDirectory}/.dotfiles/nix/home/programs/editors/vscode/keybindings.json"
      '';
    };
  };
}