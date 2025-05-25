{ config, pkgs, lib, ... }:
{
  imports = [
    ./sops.nix
    ./preferences.nix
    ../../common
  ];

  # macOS specific packages
  environment.systemPackages = with pkgs; [
    kitty
    obsidian
    slack
    raycast
  ];

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
  
  # Shell Configuration
  programs.zsh.enable = true;
  environment.shells = with pkgs; [ zsh ];
}