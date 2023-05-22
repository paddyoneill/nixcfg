{
  description = "NixOS Configuration";

  inputs = {
   nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
  };

  outputs =  { self, nixpkgs }:
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
          ];
        };
      };
    };
}
