{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.frosty;
  mkSystemAttr = path: file: rec {
    name = lib.removeSuffix ".nix" file;
    value = lib.nixosSystem {
      specialArgs = {inherit (cfg) vars;};
      modules = lib.singleton {
        imports = cfg.modules ++ lib.singleton (path + "/${file}");
        facter.reportPath =
          if builtins.pathExists (path + "/${file}")
          then lib.mkDefault (path + "/${file}")
          else null;
        networking.hostName = lib.mkDefault name;
      };
    };
  };
in {
  options.frosty = with lib; {
    clusters = mkOption {
      type = with types; attrsOf path;
      default = {};
    };

    modules = mkOption {
      type = with types; listOf deferredModule;
      default = [];
    };
  };

  config = {
    flake.nixosConfigurations = lib.pipe cfg.clusters [
      builtins.attrValues
      (lib.concatMap (path:
        lib.pipe path [
          builtins.readDir
          builtins.attrNames
          (map (mkSystemAttr path))
        ]))
      builtins.listToAttrs
    ];
  };
}
