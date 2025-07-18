{ config, pkgs, lib, ... }:

{
  home.activation = {
    linkVSCodeSettings = lib.hm.dag.entryAfter ["writeBoundary"] ''
      $DRY_RUN_CMD mkdir -p "$HOME/Library/Application Support/Code/User"
      
      # Link settings.json
      if [ ! -L "$HOME/Library/Application Support/Code/User/settings.json" ] || [ "$(readlink "$HOME/Library/Application Support/Code/User/settings.json")" != "${config.home.homeDirectory}/.dotfiles/nix/home/common/core/editors/vscode/settings.json" ]; then
        $DRY_RUN_CMD ln -sf "${config.home.homeDirectory}/.dotfiles/nix/home/common/core/editors/vscode/settings.json" "$HOME/Library/Application Support/Code/User/settings.json"
      fi
      
      # Link keybindings.json
      if [ ! -L "$HOME/Library/Application Support/Code/User/keybindings.json" ] || [ "$(readlink "$HOME/Library/Application Support/Code/User/keybindings.json")" != "${config.home.homeDirectory}/.dotfiles/nix/home/common/core/editors/vscode/keybindings.json" ]; then
        $DRY_RUN_CMD ln -sf "${config.home.homeDirectory}/.dotfiles/nix/home/common/core/editors/vscode/keybindings.json" "$HOME/Library/Application Support/Code/User/keybindings.json"
      fi
    '';
  };
}