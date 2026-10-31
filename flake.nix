{
  description = "NixOS system configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    cosmic-source.url = "github:NixOS/nixpkgs/1c89083e451e891152365b799595cf7790a43325";
  };

  outputs = { self, nixpkgs, cosmic-source }:
    let
      system = "x86_64-linux";
    in {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit cosmic-source; };
        modules = [
          ./configs/nixos/configuration.nix
          ./modules/cosmic-1.11.nix
          ./modules/cosmic-utilities.nix
        ];
      };
    };
}
