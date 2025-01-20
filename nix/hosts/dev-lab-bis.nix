{ config, pkgs, ... }:
{
  networking.hostName = "raf-devlab-bis";
  networking.computerName = "Raf Dev Lab MacBook Pro";

  users.users.raf = {
    name = "raf";
    home = "/Users/raf";
  };
}