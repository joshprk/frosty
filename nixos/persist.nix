{vars, ...}: {
  environment.persistence.${vars.persistDir} = {
    enable = true;
    hideMounts = true;
    files = ["/etc/machine-id"];
    directories = [
      "/var/log"
      "/var/lib"
    ];
  };
}
