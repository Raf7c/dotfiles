{ config, pkgs, lib, ... }:

let
  nvimConfigPath = ../../../config/nvim;
in
{
  home.file = {
    ".config/nvim" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/nix/config/nvim";
      recursive = true;
      onChange = ''
        # Checks if the submodule is initialized
        if [ -d "${config.home.homeDirectory}/.dotfiles/nix/config/nvim/.git" ]; then
          # Synchroniser les changements vers le sous-module
          rsync -av --delete "$HOME/.config/nvim/" "${config.home.homeDirectory}/.dotfiles/nix/config/nvim/" --exclude '.git'
          
          # Display a simple message
          echo "✅ Configuration Neovim synchronisée"
          echo "📝 Ccommit changes to submodule"
        fi
      '';
    };
  };
} 