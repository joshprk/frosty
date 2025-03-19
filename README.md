# Frosty

[![Documentation](https://img.shields.io/badge/docs-click_here-blue)](https://joshprk.github.io/frosty/)

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
    # Selects nixpkgs channel from flake inputs
    inherit (inputs) nixpkgs;

    # Selects Python package for all systems
    python = pkgs: pkgs.python3;

    # Path to Python project with a pyproject.toml
    src = ./.;
  };
}
```
