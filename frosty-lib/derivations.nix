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

  # Type

  ```
  mkDerivation :: Attrset -> Attrset
  ```

  # Arguments

  name
  : The name of the derivation

  version
  : A string containing the version of the derivation

  src
  : The path of the derivation source

  buildInputs
  : A function which takes pkgs to produce a list of packages for building

  buildPhase
  : A script which builds the derivation

  installPhase
  : A script which installs the derivation

  shellHook
  : A script which is executed whenever entering the shell

  nixpkgs
  : The nixpkgs channel to use

  extraOutputs
  : An attrset which merged with the generated flake outputs

  */
  mkDerivation =
    self.fn
    {
      name = self.types.str;
      version = self.types.str;
      src = self.types.path;
      buildInputs = self.types.anything.optional (pkgs: []);
      buildPhase = self.types.str.optional "";
      installPhase = self.types.str.optional "";
      # builder = self.types.path.optional null;
      shellHook = self.types.str.optional "";
      nixpkgs = self.types.anything;
      extraOutputs = self.types.anything.optional {};
    }
    (self.types.anything)
    (args:
      rec {
        devShells = self.forAllSystems (system: let
          pkgs = self.utils.getPkgs {
            inherit (args) nixpkgs;
            inherit system;
          };
        in {
          default = pkgs.stdenv.mkDerivation {
            inherit
              (args)
              name
              version
              src
              buildPhase
              installPhase
              # builder
              shellHook
              ;

            buildInputs = args.buildInputs pkgs;
          };
        });

        packages = devShells;
      }
      // args.extraOutputs);
}
