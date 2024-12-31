{ config, lib, pkgs, ... }:

{
  enable = true;
  enableZshIntegration = true;
  settings = {
    tools = {
      node = "latest";
      python = "3.9";
    };
  };
}