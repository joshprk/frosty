{lib, ...}: let
  genType = type: {
    inherit (type) name check;
    default = null;
    optional = default: let
      newType = (genType type) // {inherit default;};
      cond = (type.check default) || (default == null);
      msg = "optional arg is not of type ${type.name}";
    in lib.throwIfNot cond msg newType;
  };
in {
  raw = genType lib.types.raw;
  anything = genType lib.types.anything;

  int = genType lib.types.int;
  float = genType lib.types.float;
  str = genType lib.types.str;
  bool = genType lib.types.bool;

  path = genType lib.types.path;
  package = genType lib.types.package;

  listOf = elemType: genType (lib.types.listOf elemType);
}
