{
  config,
  lib,
  pkgs,
  ...
}: {
  services.resolved = {
    enable = lib.mkDefault true;
    dnsovertls = lib.mkDefault "true";
  };

  systemd.network = {
    enable = lib.mkDefault config.networking.useNetworkd;
  };

  networking = {
    firewall = {
      checkReversePath = lib.mkDefault "loose";
    };

    wireless = {
      iwd.enable = lib.mkDefault true;
    };

    nftables.enable = lib.mkDefault true;
    useNetworkd = lib.mkDefault true;
  };
}
