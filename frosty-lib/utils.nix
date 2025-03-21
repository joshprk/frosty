{
  self,
  lib,
  ...
}: {
  /*
  Produces an attribute mapping for all systems.

  # Example

  ```nix
  forAllSystems (system: {
    inherit system;
  });
  => {
    aarch64-linux = {
      system = "aarch64-linux";
    };

    ...
  }
  ```

  # Type

  ```
  forAllSystems :: Function -> Attrset
  ```

  # Arguments

  attrFn
  : A function which is mapped to all systems

  */
  forAllSystems =
    self.fn
    (self.types.anything)
    (self.types.anything)
    (lib.genAttrs lib.systems.flakeExposed);

  /*
  Retrieves the nixpkgs derivation for a specific system.

  # Example

  ```nix
  getPkgs {
    nixpkgs = import <nixpkgs>;
    system = "x86_64-linux";
  }
  => import <nixpkgs> {
    system = "x86_64-linux";
  }
  ```

  # Type

  ```
  getPkgs :: Attrset -> <nixpkgs>
  ```

  # Arguments

  nixpkgs
  : The nixpkgs channel to use

  system
  : The string enum of the system to use

  overlays
  : Overlay functions for nixpkgs

  allowUnfree
  : Allow unfree derivations from nixpkgs

  */
  getPkgs =
    self.fn
    {
      nixpkgs = self.types.anything;
      system = self.types.str;
      overlays = (self.types.listOf self.types.anything).optional [];
      allowUnfree = self.types.bool.optional false;
    }
    (self.types.anything)
    (args:
      import args.nixpkgs {
        inherit
          (args)
          system
          overlays
          allowUnfree
          ;
      });
}
