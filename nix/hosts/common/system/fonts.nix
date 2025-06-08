{ config, pkgs, lib, ... }:

{
  # All nerd-fonts
  fonts.packages = builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
} 