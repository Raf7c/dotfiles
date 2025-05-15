# Darwin system construction function
{ inputs, nixpkgs, darwin, home-manager, configDir, self }:

{ hostname, system, user, isLaptop ? false }:

let
  # Importer les variables d'environnement partagées
  sharedEnv = import ./shared-env.nix;
in

darwin.lib.darwinSystem {
  inherit system;
  specialArgs = { 
    inherit inputs user hostname configDir self isLaptop sharedEnv; 
  };
  modules = [
    # Base modules
    ../hosts/${hostname}.nix
    ../hosts/common/core
    ../modules/darwin
    
    # Home Manager
    home-manager.darwinModules.home-manager {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = { 
        inherit hostname isLaptop sharedEnv;
      };
      home-manager.users.${user} = import ../home;
    }
  ];
}