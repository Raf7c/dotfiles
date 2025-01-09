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
    configDir = "/Users/raf/.dotfiles/nix";
    mkSystem = import ./lib/mksystem.nix { inherit inputs nixpkgs darwin home-manager configDir; };
  in
  {
    darwinConfigurations = {
      "raf-devlab" = mkSystem {
        hostname = "raf-devlab";
        system = "aarch64-darwin";
        user = "raf";
      };
    };

    packages.aarch64-darwin.default = self.darwinConfigurations."raf-devlab".system;
  };
}