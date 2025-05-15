{ config, pkgs, isLaptop, ... }:
{
  networking = {
    hostName = "raf-devlab";
    computerName = "Raf Dev Lab MacStudio"; 
  };

  users.users.raf = {
    name = "raf";
    home = "/Users/raf";
  };
  
  # Configuration spécifique au MacStudio
  system.defaults = {
    dock = {
      tilesize = 48;
    };
  };
  
}