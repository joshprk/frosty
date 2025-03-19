# Frosty Lib

The official documentation for [Frosty](https://github.com/joshprk/frosty).

## Getting Started

Frosty has multiple use cases. It can be used for its flexible DSL sublanguage,
fast flake packaging, or consistent system configuration schema.

While the library is a work in progress, there are a few interesting features
already implemented. These features are showcased below.

### DSL

While Nix is a strongly typed language, it is difficult for a reader to easily
determine what type of inputs and outputs are expected from functions due to
the lack of type hinting. Frosty DSL attempts to remedy this by offering the
`fn` function, which generates a function with explicit error messages based on
the given type hints.

```nix
addThree = frosty.fn (frosty.types.int) (frosty.types.int) (n: n + 3)
=>
addThree 2
=> 5
```

The `fn` function also supports multiple arguments through attrsets:

```nix
add = frosty.fn
  { a = frosty.types.int;
    b = frosty.types.int;
  }
  (frosty.types.int)
  (args: with args; a + b)
=>
add { a = 1; b = 2; }
=> 3
```

### Flake Packaging

Frosty allows fast packaging through helpers that follow upstream packaging
conventions, such as using metadata from pyproject.toml for Python projects
which follow PEP-621.

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

### System Configurations

While not implemented yet, a consistent schema for system configuration is
planned and is in the works.
