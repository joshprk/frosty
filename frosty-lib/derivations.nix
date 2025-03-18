inputs: {
  mkPackage = {
    systems ? inputs.nixpkgs.lib.systems.flakeExposed,
    nixpkgs,
    name,
    pname ? null,
    version ? null,
    src,
    buildInputs ? null,
    buildPhase ? null,
    installPhase ? null,
    builder ? null,
    shellHook ? null,
  }: let
    lib = nixpkgs.lib;
    forAllSystems = lib.genAttrs systems;
  in {
    devShells = forAllSystems (
      system: let
        pkgs = import nixpkgs {
          inherit system;
        };
      in {
        default = pkgs.mkShell {
          inherit
            buildInputs
            shellHook
            ;
        };
      }
    );

    packages = forAllSystems (
      system: let
        pkgs = import nixpkgs {
          inherit system;
        };
      in {
        default = pkgs.stdenv.mkDerivation {
          inherit
            name
            version
            src
            buildInputs
            buildPhase
            installPhase
            builder
            shellHook
            ;
        };
      }
    );
  };
}
