inputs: let
  lib = inputs.nixpkgs.lib;
  args = {
    inherit inputs;
    inherit lib;
    inherit (inputs) self;
  };

  loadLib = path: let
    files = builtins.readDir path;
    names =
      builtins.filter
      (name: name != "default.nix")
      (builtins.attrNames files);
    genLibAttrs = name: let
      libPath = lib.path.append path name;
      defaultModule = lib.path.append libPath "default.nix";
      attrName = lib.strings.removeSuffix ".nix" name;
    in {
      name = attrName;
      value =
        if files.${name} == "directory"
        then
          loadLib libPath
          // (
            if builtins.pathExists defaultModule
            then import defaultModule args
            else {}
          )
        else import libPath args;
    };
    imports = map genLibAttrs names;
  in
    builtins.listToAttrs imports;

  forAllSystems = lib.genAttrs lib.systems.flakeExposed;

  aliases = let
    self = inputs.self;
  in {
    inherit
      (self.derivations)
      mkDerivation
      ;

    inherit
      (self.dsl)
      fn
      ;

    inherit forAllSystems;
  };

  extraOptions = let
    nixpkgs = inputs.nixpkgs;
  in {
    formatter =
      forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);
  };
in
  (loadLib ./.) // aliases // extraOptions
