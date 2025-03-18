{
  lib,
  ...
}: let
  genType = type: {
    inherit (type)
      name
      check;
    default = null;
    optional = default: (genType type) // {inherit default;};
  };
in {
  raw = genType lib.types.raw;
  anything = genType lib.types.anything;

  int = genType lib.types.int;
  float = genType.lib.types.float;
  str = genType lib.types.str;
  bool = genType lib.types.bool;
}
