{ config, pkgs, ... }:
{
  networking = {
    hostName = "raf-devlab";
    computerName = "Raf Dev Lab MacStudio"; 
  };

  users.users.raf = {
    name = "raf";
    home = "/Users/raf";
  };
}