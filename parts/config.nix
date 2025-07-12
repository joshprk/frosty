{
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.frosty;
  readModules = path: lib.pipe path [
    builtins.readDir
    builtins.attrNames
    (map (n: rec {
      name = lib.removeSuffix ".nix" n;
      value = lib.nixosSystem {
        modules = [
          ../nixos
          {networking.hostName = lib.mkDefault name;}
          {imports = cfg.nixosModules;}
          {hjem.extraModules = cfg.homeModules;}
          (path + "/${n}")
          (lib.mkIf (cfg.nixos != null)
            (lib.filesystem.listFilesRecursive cfg.nixos)
          )
        ];

        specialArgs = {
          inherit (cfg) homeModules;
          inherit inputs;
          var = cfg.vars;
        };
      };
    }))
    builtins.listToAttrs
  ];
in {
  flake.nixosConfigurations = lib.pipe cfg.hosts [
    builtins.attrValues
    (map readModules)
    (lib.foldl (a: b: a // b) {})
  ];
}
