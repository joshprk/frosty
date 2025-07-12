{
  description = "Opinionated flake for multi-node infrastructure";

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      flake.flakeModules = {
        default = ./parts;
      };

      flake.nixosModules.default.imports = [
        inputs.hjem.nixosModules.hjem
        ./nixos
      ];

      systems = inputs.nixpkgs.lib.systems.flakeExposed;
    };

  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.xz";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
