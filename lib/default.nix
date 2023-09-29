{ lib }:
lib.makeExtensible (self: {
  /* Concatenates packages returned by `packagesFun` for each package set.

     Type:
       concatPackages :: (packageSet -> attrsOf package) -> attrsOf packageSet -> attrsOf package

     Example:
       concatPackages
         ({ name, pkgs, ... }: {
           hello-${name} = pkgs.hello;
         })
         config.packageSets;
  */
  concatPackages = packagesFun: packageSets:
    lib.concatMapAttrs (_: packageSet: packagesFun packageSet) packageSets;

  /* Same as `concatPackages`, but allows passing a `predicate` to filter
     packages returned by `packagesFun` for convenience.

     Type:
       concatFilteredPackages :: (packageSet -> package -> bool) -> (packageSet -> attrsOf package) -> attrsOf packageSet -> attrsOf package

     Example:
       concatFilteredPackages
         ({ pkgs, ... }: lib.meta.availableOn pkgs.stdenv.hostPlatform)
         ({ name, pkgs, ... }: {
           hello-${name} = pkgs.hello;
         })
         config.packageSets;
  */
  concatFilteredPackages = predicate: packagesFun: packageSets:
    let
      filterPackages = packageSet: packages:
        lib.filterAttrs (_: package: predicate packageSet package) packages;
    in
    self.concatPackages
      (packageSet:
        filterPackages packageSet (packagesFun packageSet)
      )
      packageSets;

  /* A predicate exposed for convenience that filters packages that are not
     marked as broken and are available for the host platform.
  */
  availableOnHostPlatform = { pkgs, ... }: package:
    !package.meta.broken && lib.meta.availableOn pkgs.stdenv.hostPlatform package;
})
