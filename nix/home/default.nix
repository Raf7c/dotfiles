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
    ".zshrc".source = mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/nix/home/common/core/.zshrc";
    # asdf
    ".tool-versions".source = mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/nix//home/common/core/.tool-versions";
    # prettier
    ".prettierrc.json".source = mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/nix/home/common/core/formatting-config/.prettierrc.json";
    # eslint
  ".eslintrc.json".source = mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/nix/home/common/core/linting-config/.eslintrc.json";
  # vscode - correction des chemins
  "Library/Application Support/Code/User/settings.json".source = mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/nix/home/common/core/vscode/settings.json";
  "Library/Application Support/Code/User/keybindings.json".source = mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/nix/home/common/core/vscode/keybindings.json";
};

  imports = [
    ./common/core/asdf.nix
    ./common/core/nvim.nix
    # Import nvim directly
  ];

  programs = {
    git = import ../home/common/core/git.nix {inherit config pkgs; };
    starship = import ../home/common/core/starship.nix { inherit pkgs; };
    fzf = import ../home/common/core/fzf.nix { inherit pkgs; };
    kitty = import ../home/common/core/kitty.nix {inherit config pkgs; };
  };
}