{ inputs, nixpkgs, darwin }:

{ hostname, system, user }:

darwin.lib.darwinSystem {
  inherit system;
  specialArgs = { inherit inputs user hostname; };
  modules = [
    ../modules/darwin
    # Nous ajouterons d'autres modules ici plus tard
  ];
}