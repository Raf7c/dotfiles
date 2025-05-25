{
  description = "Configuration système avec Nix pour macOS et NixOS";

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
    mkDarwinSystem = import ./nix/lib/mkdarwin.nix { inherit inputs nixpkgs darwin home-manager configDir self; };
  in
  {
    # macOS configurations
    darwinConfigurations = {
      "raf-devlab" = mkDarwinSystem {
        hostname = "dev-lab";
        system = "aarch64-darwin";
        user = "raf";
        isLaptop = false;
      };
      "raf-devlab-bis" = mkDarwinSystem {
        hostname = "dev-lab-bis";
        system = "aarch64-darwin";
        user = "raf";
        isLaptop = true;
      };
    };

    # Future NixOS configurations
    # nixosConfigurations = {
    #   "nixos-desktop" = nixpkgs.lib.nixosSystem {
    #     system = "x86_64-linux";
    #     modules = [ ./nix/nixos/hosts/desktop.nix ];
    #   };
    # };
  };
} 