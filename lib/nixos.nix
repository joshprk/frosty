{
  config,
  lib,
  ...
}: let
  cfg = config.frosty;
in {
  options.frosty = with lib; {
    hosts = mkOption {
      type = with types; attrsOf path;
      description = ''
        An attrset of clusters represented as paths to directories, with each
        directory containing the instances that cluster contains.

        This flake library is cluster-centric, but a non-cluster setup can
        simply use a catch-all cluster to define its hosts. A cluster is
        nothing more than a logical separation and does not affect any options
        in the `lib.nixosSystem`.
      '';
      default = {};
      example = {
        all = ./hosts;
      };
    };

    nixosModules = mkOption {
      type = with types; nullOr path;
      description = ''
        A path which leads to a directory containing common NixOS modules which
        are to be applied to all hosts in all clusters.
      '';
      default = null;
      example = ./nixos;
    };

    parts = mkOption {
      type = with types; nullOr path;
      description = ''
        A path which leads to a directory containing flake modules which are to
        be directly used by this flake.
      '';
      default = null;
      example = ./parts;
    };

    vars = mkOption {
      type = with types; attrs;
      description = ''
        Variables which are passed as `specialArgs` in `lib.nixosSystem`. This
        is useful for static globals such as Kubernetes control server IPs.

        These variables are accessible through the `var` specialArgs for all
        hosts in all clusters.
      '';
      default = {};
      example = {
        k3s-cluster.server-ip = "0.0.0.0";
      };
    };
  };

  config = {
    imports = lib.mkIf (cfg.parts != null) [
      cfg.parts
    ];

    flake.nixosConfigurations = let
      readHosts = path: lib.pipe path [
        builtins.readDir
        builtins.attrNames
        (map (name: path + "/${name}")
      ];
      mkSystem = system: lib.nixosSystem {
        specialArgs = {var = cfg.vars;};
        modules =
          lib.filesystem.listFilesRecursive cfg.nixosModules
          ++ [system];
      };
    in
      lib.pipe cfg.hosts [
        builtins.attrValues
        (lib.foldl (a: b: a // readHosts b) {})
        (builtins.mapAttrs mkSystem)
      ];
  };
}
