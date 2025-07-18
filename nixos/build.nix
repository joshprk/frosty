{
  lib,
  inputs,
  vars,
  ...
}: {
  programs.nh = {
    enable = lib.mkDefault true;
    flake = lib.mkDefault "git+${vars.git}";
  };

  nix.settings = {
    auto-allocate-uids = lib.mkDefault true;
    use-xdg-base-directories = lib.mkDefault true;
    extra-experimental-features = [
      "nix-command"
      "flakes"
      "auto-allocate-uid"
      "pipe-operators"
    ];
  };

  nixpkgs.config = {
    allowUnfree = lib.mkDefault true;
    cudaSupport = lib.mkDefault true;
  };

  system = with inputs; {
    configurationRevision = self.rev or self.dirtyRev or "unknown-dirty";
    disableInstallerTools = lib.mkDefault true;
  };
}
