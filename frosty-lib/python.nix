{
  self,
  pyproject-nix,
  ...
}: {
  /*
  Produces a Python package flake from pyproject.toml metadata

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
  mkPythonProject :: Attrset -> Attrset
  ```

  # Arguments

  nixpkgs
  : The nixpkgs channel to use

  python
  : A function which takes system nixpkgs and returns a Python package

  src
  : The path to the Python project containing a pyproject.toml file

  extraOutputs
  : An attrset which merged with the generated flake outputs

  */
  mkPythonProject =
    self.fn
    {
      nixpkgs = self.types.anything;
      python = self.types.package;
      src = self.types.path;
      extraOutputs = self.types.anything.optional {};
    }
    (self.types.anything)
    (args: let
      project = pyproject-nix.lib.project.loadPyproject {
        projectRoot = args.src;
      };
    in
      {
        packages = self.forAllSystems (system: let
          pkgs = self.utils.getPkgs {
            inherit (args) nixpkgs;
            inherit system;
          };

          pythonPackage = args.python pkgs;

          attrs = project.renderers.buildPythonPackage {
            python = pythonPackage;
          };
        in {
          default = pythonPackage.pkgs.buildPythonPackage attrs;
        });
      }
      // args.extraOutputs);
}
