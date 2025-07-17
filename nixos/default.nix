{
  config,
  lib,
  pkgs,
  inputs,
  vars,
  ...
}: {
  nix.settings = {
    extra-experimental-features = [
      "nix-command"
      "flakes"
    ];
  };
}
