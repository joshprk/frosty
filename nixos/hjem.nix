{lib, vars, ...}: {
  programs.bash = {
    interactiveShellInit = lib.mkDefault ''
      xdg_state_home="''${xdg_state_home:-$home/.local/state}"
      [ -d "$xdg_state_home"/bash ] || mkdir -p "$xdg_state_home"/bash
      export histfile="$xdg_state_home"/bash/history
    '';
  };

  programs.fish = {
    interactiveShellInit = lib.mkDefault ''
      function fish_command_not_found
        echo "$argv[1]: command not found"
      end
    '';
  };

  services.dbus = {
    implementation = lib.mkDefault "broker";
  };

  services.userborn = {
    enable = lib.mkDefault true;
    passwordFilesLocation = "/var/lib/nixos";
  };

  hjem = {
    clobberByDefault = lib.mkDefault true;
    extraModules = vars.homeModules;
  };

  users = {
    mutableUsers = lib.mkDefault false;
  };
}
