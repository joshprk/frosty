{
  self,
  lib,
  ...
}: {
  forAllSystems =
    self.fn
    (self.types.anything)
    (self.types.anything)
    (attrs: lib.genAttrs lib.systems.flakeExposed attrs);
}
