{
  self,
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
    });
}
