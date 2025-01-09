{ inputs, nixpkgs, darwin, home-manager, configDir }:

{ hostname, system, user, extraModules ? [] }:

darwin.lib.darwinSystem {
  inherit system;
  specialArgs = { inherit inputs user hostname configDir; };
  modules = [
    (configDir + "/hosts/dev-lab.nix")
    (configDir + "/hosts/common/core")
    (configDir + "/modules/darwin")
    home-manager.darwinModules.home-manager {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.${user} = import (configDir + "/home");
    }
  ] ++ extraModules;
}