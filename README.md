# Frosty

The fastest way to get started with Nix packaging and configuration.

## Example

```nix
{
  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs?ref=nixos-unstable";
    };

    frosty = {
      url = "github:joshprk/frosty";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: inputs.frosty.mkPythonProject {
    inherit (inputs) nixpkgs;
    python = pkgs: pkgs.python3;
    src = ./.;
  };
}
```
