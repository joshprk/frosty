{
  config,
  lib,
  pkgs,
  ...
}: {
  boot = {
    consoleLogLevel = lib.mkDefault 0;

    initrd = {
      systemd.enable = lib.mkDefault true;
      verbose = lib.mkDefault false;
    };

    kernelParams = [
      (lib.mkIf config.boot.plymouth.enable "plymouth.use-simpledrm")
      "quiet"
    ];

    loader.limine = {
      enable = lib.mkDefault true;
      maxGenerations = lib.mkDefault 10;
    };

    plymouth = {
      enable = lib.mkIf (config.services.xserver.enable) (lib.mkDefault true);
    };
  };
}
