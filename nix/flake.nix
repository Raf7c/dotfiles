{
  description = "Configuration système avec Nix pour macOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, darwin, home-manager }@inputs: 
  let 
    configDir = "${self}/nix";
    mkSystem = import ./lib/mksystem.nix { inherit inputs nixpkgs darwin home-manager configDir self; };
  in
  {
    darwinConfigurations = {
      "raf-devlab" = mkSystem {
        hostname = "dev-lab";
        system = "aarch64-darwin";
        user = "raf";
        isLaptop = false;
      };
      "raf-devlab-bis" = mkSystem {
        hostname = "dev-lab-bis";
        system = "aarch64-darwin";
        user = "raf";
        isLaptop = true;
      };
    };
  };
}