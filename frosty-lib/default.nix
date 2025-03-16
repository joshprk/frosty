inputs: {
  python = import ./python inputs;
  rust = import ./rust inputs;

  mkPackage = import ./derivation.nix inputs;
}
