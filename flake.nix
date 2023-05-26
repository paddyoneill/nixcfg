{
  description = "NixOS Configuration";

  inputs = {
   nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
   home-manager = {
    url = "github:nix-community/home-manager/release-22.11";
    inputs.nixpkgs.follows = "nixpkgs";
   };
  };

  outputs =  { self, nixpkgs, home-manager }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
      };
      lib = nixpkgs.lib;
    in {
      nixosConfigurations = {
        ganymede = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./configuration.nix
            home-manager.nixosModules.home-manager
          ];
        };
      };
    };
}
