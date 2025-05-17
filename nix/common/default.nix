{ config, pkgs, ... }:

{
  # Import all common modules
  imports = [
    ./nix.nix
    ./fonts
    ./packages/base.nix
    ./packages/development.nix
    ./packages/media.nix
  ];
} 