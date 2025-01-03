{ config, lib, pkgs, ... }:

{
  
    enable = true;
    config = {
      theme = "Dracula";
      italic-text = "always";
      style = "numbers,changes,header";
    };
    themes = {
      dracula = {
        src = pkgs.fetchFromGitHub {
          owner = "dracula";
          repo = "sublime";
          rev = "master";
          sha256 = "sha256-8mCovVSrBjtFi5q+XQdqAaqOt3Q+Fo29eIDwECOViro=";
        };
        file = "Dracula.tmTheme";
      };
    };

}