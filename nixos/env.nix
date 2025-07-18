{lib, ...}: {
  environment = {
    defaultPackages = lib.mkDefault [];
    enableAllTerminfo = lib.mkDefault true;
  };

  programs.command-not-found = {
    enable = lib.mkDefault false;
  };

  system.etc.overlay = {
    enable = lib.mkDefault true;
    mutable = lib.mkDefault true;
  };
}
