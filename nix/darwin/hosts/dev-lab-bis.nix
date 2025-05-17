{ config, pkgs, isLaptop, ... }:
{
  networking = {
    hostName = "raf-devlab-bis";
    computerName = "Raf Dev Lab MacBook Pro"; 
  };

  users.users.raf = {
    name = "raf";
    home = "/Users/raf";
  };
  
  # Configuration spécifique au MacBookPro
  system.defaults = {
    dock = {
      tilesize = 42;
    };
    
    # Trackpad
    trackpad = {
      Clicking = true;
    };
  };

  homebrew = {
    casks = ["aldente"];
  };
}