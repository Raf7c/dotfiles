{ config, pkgs, lib, ... }:

{
  home.file = {
    "Library/Application Support/Code/User/settings.json" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/nix/home/programs/editors/vscode/settings.json";
      onChange = ''
        if [ -f "$HOME/Library/Application Support/Code/User/settings.json" ]; then
          cp "$HOME/Library/Application Support/Code/User/settings.json" "${config.home.homeDirectory}/.dotfiles/nix/home/programs/editors/vscode/settings.json"
        fi
      '';
    };
    "Library/Application Support/Code/User/keybindings.json" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/nix/home/programs/editors/vscode/keybindings.json";
      onChange = ''
        if [ -f "$HOME/Library/Application Support/Code/User/keybindings.json" ]; then
          cp "$HOME/Library/Application Support/Code/User/keybindings.json" "${config.home.homeDirectory}/.dotfiles/nix/home/programs/editors/vscode/keybindings.json"
        fi
      '';
    };
  };
}