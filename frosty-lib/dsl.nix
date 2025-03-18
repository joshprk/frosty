{
  self,
  lib,
  ...
}: {
  fn = argType: returnType: lambda: arg: let
    checkArg = value:
      if (builtins.typeOf arg) == "set"
      then
        builtins.mapAttrs
        (name: value: let
          resolved =
            if arg ? name
            then value
            else argType.${name}.default;
          cond = argType.${name}.check resolved;
          msg = ''arg ${name} is not of type ${argType.${name}.name}'';
        in
          lib.throwIfNot cond msg resolved)
        arg
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
