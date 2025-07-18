{
  config,
  lib,
  pkgs,
  vars,
  ...
}: {
  age = {
    rekey = {
      masterIdentities = [vars.identity];
      storageMode = "local";
      localStorageDir = vars.secrets + "/rekeyed/${config.networking.hostName}";
    };

    secrets = lib.pipe vars.secrets [
      lib.filesystem.listFilesRecursive
      (lib.filter (lib.hasSuffix ".age"))
      (lib.mapListToAttrs (file: {
        name = lib.removeSuffix ".age" file;
        value.rekeyFile = vars.secrets + "/${file}";
      }))
    ];
  };
}
