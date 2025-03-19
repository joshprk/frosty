{self, ...}: {
  /*
  Produces a flake containing package derivations for all systems.

  # Example
  ```nix
  mkDerivation {
    name = "printf";
    version = "4.0.0";
    src = pkgs.fetchgit {
      url = "https://github.com/mpaland/printf";
      hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
    };
    buildInputs = ''
      gcc printf.c -o printf
    '';
  }
  => {
    packages = {
      aarch64-linux.default = pkgs.stdenv.mkDerivation {
        inherit (args)
          name
          version
          src
          buildInputs;
      };

      ...
    };
  }
  */
  mkDerivation =
    self.fn
    {
      name = self.types.str;
      version = self.types.str;
      src = self.types.path;
      buildInputs = (self.types.listOf self.types.package).optional [];
      buildPhase = self.types.str.optional "";
      installPhase = self.types.str.optional "";
      builder = self.types.path.optional null;
      shellHook = self.types.str.optional "";
      nixpkgs = self.types.anything;
      extraOutputs = self.types.anything;
    }
    (self.types.anything)
    (args: let
      getPkgs = nixpkgs: system:
        import nixpkgs {
          inherit system;
        };
    in
      rec {
        devShells = self.forAllSystems (system: let
          pkgs = getPkgs system args.nixpkgs;
        in {
          default = pkgs.stdenv.mkDerivation {
            inherit
              (args)
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
        });

        packages = devShells;
      }
      // args.extraOutputs);
}
