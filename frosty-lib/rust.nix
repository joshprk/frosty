{
  self,
  rust-overlay,
  ...
}: {
  /*
  Produces a Rust package flake using rust-overlay

  # Example

  ```nix
  mkPythonProject {
    nixpkgs = import <nixpkgs>;
    python = pkgs: pkgs.python3;
    src = ./.;
  }
  => <thunk>
  ```

  # Type

  ```
  mkRustPackage :: Attrset -> Attrset
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

  channel
  : Pass extra arguments to nixpkgs import

  extraOutputs
  : An attrset which merged with the generated flake outputs

  rust
  : A function which takes rust-bin and returns the branch to use

  */
  mkRustPackage =
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
      channel = self.types.anything.optional {};
      extraOutputs = self.types.anything.optional {};
      rust =
        self.types.anything.optional
        (rust-bin: rust-bin.stable.latest.default);
    }
    (self.types.anything)
    (
      args:
        self.derivations.mkDerivation
        (
          args
          // {
            buildInputs = pkgs: (args.buildInputs pkgs) ++ [(args.rust pkgs.rust-bin)];
            channel.overlays =
              (args.channel.overlays or [])
              ++ [(import rust-overlay)];
          }
        )
    );
}
