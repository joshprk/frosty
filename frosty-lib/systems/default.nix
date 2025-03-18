{
  self,
  lib,
  inputs,
  ...
}: let
  lib = inputs.nixpkgs.lib;
in {
  mkSystem = {
    hosts ? {},
    users ? {},
    modules ? {},
    userModules ? {},
    formatter ? {},
    ...
  }: {
    nixosConfigurations =
      lib.attrsets.concatMapAttrs
      (hostName: attrs: {
        ${hostName} = let
          frostyModule = {
            system = {
              inherit (attrs) stateVersion;
            };
          };
        in lib.nixosSystem {
          inherit (attrs) specialArgs;
          modules =
            [frostyModule]
            //
            attrs.modules;
        };
      })
      hosts;
  };

  outputs = inputs:
    inputs.frosty.mkSystem {
      modules = [];

      hosts = {
        PC = {
          stateVersion = "25.05";
          specialArgs = {};
          modules = [];
        };
      };

      users = {
        joshua = {
          username = "joshua";
          directory = "/home/joshua";
          stateVersion = "25.05";
          modules = [];
        };
      };

      formatter = pkgs: pkgs.alejandra;
    };
}
