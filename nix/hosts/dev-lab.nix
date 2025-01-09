{ config, pkgs, ... }:

{
  networking.hostName = "raf-devlab";
  networking.computerName = "Raf Dev Lab MacStudio";

  users.users.raf = {
    name = "raf";
    home = "/Users/raf";
  };
  


}