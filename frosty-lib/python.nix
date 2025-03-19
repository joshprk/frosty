{
  self,
  lib,
  pyproject-nix,
  ...
}: {
  mkPythonProject =
    self.fn
    {
      nixpkgs = self.types.anything;
      python = self.types.package;
      src = self.types.path;
    }
    (self.types.anything)
    (args: let
      project = pyproject-nix.lib.project.loadPyproject {
        projectRoot = args.src;
      };
    in {
      packages = self.forAllSystems (system: let
        
      in {

      });
    });
}
