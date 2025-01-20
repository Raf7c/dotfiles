{ config, lib, pkgs, ... }:
{
  enable = true;
  config = {
    theme = "Catppuccin-latte";
    italic-text = "always";
    style = "numbers,changes,header";
  };

  themes = {
    "Catppuccin-latte" = {
      src = pkgs.fetchFromGitHub {
        owner = "catppuccin";
        repo = "bat";
        rev = "master";
        sha256 = "sha256-6WVKQErGdaqb++oaXnY3i6/GuH2FhTgK0v4TN4Y0Wbw=";
      };
      file = "Catppuccin-latte.tmTheme";
    };
  };
}