{
  description = "Frosty Lib";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs?ref=nixos-unstable";
    };

    pyproject-nix = {
      url = "github:pyproject-nix/pyproject.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: let
    nixpkgs = inputs.nixpkgs;
    lib = nixpkgs.lib;
    forAllSystems = lib.genAttrs lib.systems.flakeExposed;
    frosty-lib = import ./frosty-lib inputs;
  in {
    inherit (frosty-lib)
      mkPackage;

    inherit (frosty-lib.python)
      mkPythonProject;

    inherit (frosty-lib.rust)
      mkRust;

    formatter =
      forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);
  };
}
