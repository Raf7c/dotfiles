{ config, pkgs, lib, isLaptop, ... }:

{
  imports = [
    ./develop.nix
    
    # Add other profiles here
    # ./gaming.nix
    # ./media.nix
    # ./productivity.nix

  ];
} 