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
      type = with types; listOf deferredModule;
      description = "A list of nixos modules to automatically import.";
      default = [];
      example = [
        ./nixos/flake-module.nix
      ];
    };

    homeModules = mkOption {
      type = with types; listOf deferredModule;
      description = "A list of home modules to automatically import for all users.";
      default = [];
      example = [
        ./home/flake-module.nix
      ];
    };

    nixos = mkOption {
      type = with types; nullOr path;
      apply = opt:
        if opt != null
        then lib.filesystem.listFilesRecursive opt
        else [];
      description = ''
        A path which leads to a directory containing common NixOS modules which
        are to be applied to all hosts in all clusters.
      '';
      default = null;
      example = ./nixos;
    };

    parts = mkOption {
      type = with types; nullOr path;
      apply = opt:
        if opt != null
        then lib.filesystem.listFilesRecursive opt
        else [];
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
    flake.nixosConfigurations = let
      readHosts = path: lib.pipe path [
        builtins.readDir
        builtins.attrNames
        (map (file: rec {
          name = lib.removeSuffix ".nix" file;
          value = lib.nixosSystem {
            modules = cfg.nixosModules ++ [
              {networking.hostName = lib.mkDefault name;}
              config.flake.nixosModules.default
              (path + "/${file}")
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
    in
      lib.pipe cfg.hosts [
        builtins.attrValues
        (lib.foldl (a: b: a // readHosts b) {})
      ];

    flake.nixosModules.default = {
      config,
      lib,
      pkgs,
      var ? {},
      homeModules ? [],
      ...
    }: {
      imports = [
        config.flake.nixosModules.hjem
      ];

      hjem = {
        clobberByDefault = lib.mkDefault true;
        extraModules = homeModules;
        specialArgs = {inherit var;};
        linker = lib.mkDefault inputs.hjem.packages.${pkgs.system}.smfh;
      };

      nix.settings.extra-experimental-features = lib.mkDefault [
        "flakes"
        "nix-command"
      ];
    };
  };
}
