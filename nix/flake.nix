{
  description = "Configuration système avec Nix pour macOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, darwin }@inputs: 
  let 
    configDir = "/Users/raf/.dotfiles/nix";  # Définissez configDir ici
    mkSystem = import ./lib/mksystem.nix { inherit inputs nixpkgs darwin configDir; };
  in
  {
    darwinConfigurations = {
      "dev-lab" = mkSystem {
        hostname = "dev-lab";
        system = "aarch64-darwin";
        user = "raf";
      };
    };

    packages.aarch64-darwin.default = self.darwinConfigurations."dev-lab".system;
  };
}