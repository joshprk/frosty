{
  description = "Opinionated flake for multi-node infrastructure";

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      flake = {
        inherit (inputs.flake-parts) lib;
        flakeModules = let
          inherit (inputs.nixpkgs.lib.modules) importApply;
        in rec {
          frosty = importApply ./parts {local = inputs.self;};
          default = frosty;
        };
      };

      perSystem = {pkgs, ...}: {
        formatter = pkgs.alejandra;
      };

      systems = inputs.nixpkgs.lib.systems.flakeExposed;
    };

  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.xz";

    agenix = {
      url = "github:moraxyc/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix-rekey = {
      url = "github:oddlama/agenix-rekey";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    facter = {
      url = "github:nix-community/nixos-facter-modules";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence = {
      url = "github:nix-community/impermanence";
    };
  };
}
