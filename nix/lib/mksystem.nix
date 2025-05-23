# Darwin system construction function
{ inputs, nixpkgs, darwin, home-manager, configDir, self }:

{ hostname, system, user, extraModules ? [] }:

darwin.lib.darwinSystem {
  inherit system;
  specialArgs = { inherit inputs user hostname configDir self ; };
  modules = [
    (configDir + "/hosts/${hostname}.nix")
    (configDir + "/hosts/common/core")
    (configDir + "/modules/darwin")
    home-manager.darwinModules.home-manager {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.${user} = import (configDir + "/home");
    }
  ] ++ extraModules;
}