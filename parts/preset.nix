{
  config,
  lib,
  pkg,
  ...
}: let
  cfg = config.frosty;
in {
  options.frosty = with lib; {
    preset = mkOption {
      type = with types; bool;
      default = false;
    };
  };

  config = lib.mkIf cfg.preset {
    frosty.modules = [../nixos];
  };
}
