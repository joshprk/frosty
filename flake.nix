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

  outputs = inputs: {
    mkPythonProject = {
      nixpkgs,
      python,
      src,
      allowUnfree ? true,
    }: let
      lib = nixpkgs.lib;
      forAllSystems = lib.genAttrs lib.systems.flakeExposed;

      project = inputs.pyproject-nix.lib.project.loadPyproject {
        projectRoot = src;
      };

      getPkgs = system:
        import nixpkgs {
          inherit
            system
            allowUnfree;
        };
    in {
      devShells = forAllSystems (system: let
        pkgs = getPkgs system;
        pythonPackage = python pkgs;
        pythonDeps = project.renderers.withPackages {
          python = pythonPackage;
        };
      in {
        default = pkgs.mkShell {
          packages = [(pythonPackage.withPackages pythonDeps)];
        };
      });

      packages = forAllSystems (system: let
        pkgs = getPkgs system;
        pythonPackage = python pkgs;
        attrs = project.renderers.buildPythonPackage {
          python = pythonPackage;
        };
      in {
        default = pythonPackage.pkgs.buildPythonPackage attrs;
      });
    };

    mkRust = {
      nixpkgs,
      rust,
      src,
      allowUnfree ? false,

      name,
      version,

      buildInputs,
      buildPhase,
      installPhase,
      builder,

      shellHook,
    }: let
      lib = nixpkgs.lib;
      forAllSystems = lib.genAttrs lib.systems.flakeExposed;

      getPkgs = system:
        import nixpkgs {
          inherit
            system
            allowUnfree;

          overlays = [
            (import inputs.rust-overlay)
          ];
        };

    in {
      packages = forAllSystems (system: let
        pkgs = getPkgs system;
        systemBuildInputs = buildInputs pkgs;
      in {
        default = pkgs.stdenv.mkDerivation {
          inherit
            name
            version
            src
            buildPhase
            installPhase
            builder
            shellHook;

          buildInputs = 
            with pkgs; [(rust rust-bin)]
            // systemBuildInputs;
        };
      });
    };
  };
}
