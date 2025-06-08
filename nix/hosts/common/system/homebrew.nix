{ config, pkgs, lib, ... }:
{
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      cleanup = "zap"; 
      upgrade = true;
    };

    taps = [ ];

    brews = [
      "mas"
      "xz"
      "zlib"
      "openssl"
      "readline"
    ];

    casks = [
      "cleanmymac"
      "notion"
      "notion-calendar"
      
      "figma"
      "docker"
      "cursor"
      
      "istat-menus"
      
      # Finance
      "ledger-live"
    ];
    
    masApps = { 
      "ZSA Keymapp" = 6472865291; 
    };
  };
} 