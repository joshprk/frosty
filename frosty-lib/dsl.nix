{lib, ...}: {
  /*
  Creates a function f: X -> Y where the types of X and Y can be specified and
  checked for type errors before execution.

  # Example

  ```nix
  addThree = frosty.fn (frosty.types.int) (frosty.types.int)
    (n: n + 3)
  =>
  addThree 3
  =>
  6
  ```

  # Type

  ```
  fn :: Unknown -> Unknown -> lambda
  ```

  # Arguments

  argType
  : A single type or an attrset of input argument types.

  returnType
  : A single type which is the expected return type of the lambda

  lambda
  : The function to wrap with type-checking
  */
  fn = argType: returnType: lambda: arg: let
    checkArg = value:
      if (builtins.typeOf arg) == "set"
      then
        builtins.mapAttrs
        (name: type: let
          resolved =
            if builtins.hasAttr name arg
            then arg.${name}
            else
              let
                cond = builtins.hasAttr "default" type;
                msg = "required arg ${name} was not given";
              in lib.throwIfNot cond msg type.default;
          cond = type.check resolved || (type.default == null);
          msg = ''arg ${name} is not of type ${type.name}'';
        in
          lib.throwIfNot cond msg resolved)
        argType
      else let
        resolved =
          if arg != null
          then arg
          else
            let
              cond = builtins.hasAttr "default" arg;
              msg = "required arg was not given";
            in lib.throwIfNot cond msg argType.default;
        cond = (argType.check resolved) || (argType.default == null);
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
