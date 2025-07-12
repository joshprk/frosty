{lib, ...}: {
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
    };

    nixos = mkOption {
      type = with types; nullOr path;
      description = ''
        A path which leads to a directory containing common NixOS modules which
        are to be applied to all hosts in all clusters.
      '';
      default = null;
    };

    nixosModules = mkOption {
      type = with types; listOf deferredModule;
      description = "A list of nixos modules to automatically import.";
      default = [];
    };

    homeModules = mkOption {
      type = with types; listOf deferredModule;
      description = "A list of home modules to automatically import for all users.";
      default = [];
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
    };
  };
}
