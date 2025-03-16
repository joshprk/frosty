inputs: {
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
}
