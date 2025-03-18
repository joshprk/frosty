inputs: let
  nixpkgs = inputs.nixpkgs;
  lib = nixpkgs.lib;
  forAllSystems = lib.genAttrs lib.systems.flakeExposed;
  loadLib = path: let
    files = builtins.readDir path;
    names =
      builtins.filter
      (name: name != "default.nix")
      (builtins.attrNames files);
    libList =
      map
      (name: let
        libPath = lib.path.append path name;
      in {
        name = lib.strings.removeSuffix ".nix" name;
        value =
          if files.${name} == "directory"
          then
            loadLib libPath
            // (
              if builtins.pathExists (lib.path.append libPath "default.nix")
              then import (lib.path.append libPath "default.nix") inputs
              else {}
            )
          else import libPath inputs;
      })
      names;
  in
    builtins.listToAttrs libList;
in
  loadLib ./.
  // {
    inherit (inputs.self.derivations)
      mkPackage;

    formatter =
      forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);
  }
