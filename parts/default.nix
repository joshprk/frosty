{local, ...}: {
  imports = [
    ./clusters.nix
    ./nixos.nix
  ];

  config = {
    frosty.modules = with local.inputs; [
      agenix.nixosModules.default
      agenix-rekey.nixosModules.default
      disko.nixosModules.disko
      facter.nixosModules.facter
      hjem.nixosModules.hjem
      impermanence.nixosModules.impermanence
      ../nixos
    ];
  };
}
