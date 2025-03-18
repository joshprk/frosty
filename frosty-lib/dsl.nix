{lib, ...}: {
  fn = argType: returnType: lambda: arg: let
    checkArg = value:
      if (builtins.typeOf arg) == "set"
      then
        builtins.mapAttrs
        (name: type: let
          resolved =
            if builtins.hasAttr name arg
            then arg.${name}
            else type.default;
          cond = type.check resolved;
          msg = ''arg ${name} is not of type ${type.name}'';
        in
          lib.throwIfNot cond msg resolved)
        argType
      else let
        resolved =
          if arg != null
          then arg
          else argType.default;
        cond = argType.check resolved;
        msg = "arg is not of type ${argType.name}";
      in
        lib.throwIfNot cond msg resolved;
    checkReturn = value: let
      cond = returnType.check value;
      msg = "return value is not of type ${returnType.name}";
    in
      lib.throwIfNot cond msg value;
  in
    checkReturn (lambda (checkArg arg));
}
