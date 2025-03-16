inputs: {
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
}
