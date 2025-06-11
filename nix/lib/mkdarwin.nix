# Darwin system construction function
{ inputs, nixpkgs, darwin, home-manager, configDir, self }:

{ hostname, system, user, isLaptop ? false }:

let
  # Import shared environment variables
  sharedEnv = import ./shared-env.nix;
in

darwin.lib.darwinSystem {
  inherit system;
  
  specialArgs = { 
    inherit inputs user hostname configDir self isLaptop sharedEnv; 
  };
  
  modules = [
    # Base modules 
    ../hosts/darwin/${hostname}.nix
    
    # Home Manager
    home-manager.darwinModules.home-manager {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = { 
        inherit hostname isLaptop sharedEnv;
      };
      home-manager.users.${user} = import ../home/${
        if hostname == "dev-lab" then "dev-lab.nix"
        else if hostname == "dev-lab-bis" then "dev-lab-bis.nix"
        else throw "Unknown hostname ${hostname}"
      };
    }
  ];
}