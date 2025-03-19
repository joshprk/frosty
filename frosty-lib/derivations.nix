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
      buildInputs = self.types.str.optional "";
      nixpkgs = self.types.anything;
    }
    (self.types.anything)
    (args: {
      packages = self.forAllSystems (system: let
        pkgs = import args.nixpkgs {
          inherit system;
        };
      in {
        default = pkgs.stdenv.mkDerivation {
          inherit
            (args)
            name
            version
            src
            buildInputs
            ;
        };
      });
    });
}
