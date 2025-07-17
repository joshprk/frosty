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

    vars.secrets = mkOption {
      type = with types; listOf path;
      default = [];
    };

    vars.identities = mkOption {
      type = with types; listOf path;
      default = [];
    };

    vars.git = mkOption {
      type = with types; nullOr str;
      default = null;
    };
  };
}
