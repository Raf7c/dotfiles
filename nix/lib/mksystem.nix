{ inputs, nixpkgs, darwin, configDir }:

{ hostname, system, user }:

darwin.lib.darwinSystem {
  inherit system;
  specialArgs = { inherit inputs user hostname configDir; };
  modules = [
    (configDir + "/hosts/${hostname}.nix")
    (configDir + "/hosts/common/core")
    (configDir + "/modules/darwin")
  ];
}