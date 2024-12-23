{ config, lib, pkgs, self, ... }:

{
  environment.systemPackages = with pkgs; [
    neovim
    git
    tree
    curl
  ];
  homebrew = {
    enable = true;
    brews = [
      "mas"
    ];
    casks = [
      "arc"
      "discord"
    ];
    masApps = {
     # "Yoink" = 457622435;
    };
    onActivation.cleanup = "zap";
  };

  users.users.raf.home = "/Users/raf";
  services.nix-daemon.enable = true;
  nix.settings.experimental-features = "nix-command flakes";
  programs.zsh.enable = true;  # default shell on catalina
  system.configurationRevision = self.rev or self.dirtyRev or null;
  system.stateVersion = 4;
  nixpkgs.hostPlatform = "aarch64-darwin";
  security.pam.enableSudoTouchIdAuth = true;
}
