{lib, ...}: {
  options.frosty = with lib; {
    vars.nixosModules = mkOption {
      type = with types; listOf deferredModule;
      default = [];
    };

    vars.homeModules = mkOption {
      type = with types; listOf deferredModule;
      default = [];
    };

    vars.identity = mkOption {
      type = with types; nullOr path;
      default = null;
    };

    vars.secrets = mkOption {
      type = with types; nullOr path;
      default = null;
    };

    vars.git = mkOption {
      type = with types; nullOr str;
      default = null;
    };

    vars.persistDir = mkOption {
      type = with types; str;
      default = "/nix/persist";
    };
  };
}
