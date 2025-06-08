{ config, pkgs, ... }:

{
  imports = [
    ./darwin.nix
    ./sops.nix
    ../system/preferences-macos.nix
    ../system/fonts.nix
    ../system/homebrew.nix
    ../profiles/media.nix
    ../profiles/development.nix
    ../profiles/productivity.nix
  ];
}