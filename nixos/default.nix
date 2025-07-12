{
  config,
  lib,
  pkgs,
  ...
}: {
  nix.settings = {
    extra-experimental-features = lib.mkDefault [
      "flakes"
      "nix-command"
    ];
  };
}
