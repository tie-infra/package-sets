# Package Sets

A module for flake-parts to access multiple Nixpkgs evaluations per system. For
example, to check Nixpkgs overlay against different configurations.

## Usage

Warning: this module is currently experimental and things are likely to change.

```nix
{ self, inputs, package-sets-lib, ... }:
let
  inherit (package-sets-lib)
    concatFilteredPackages
    availableOnHostPlatform;
in
{
  perSystem = { system, config, ... }:
    let
      args = {
        localSystem = { inherit system; };
        overlays = [ self.overlays.default ];
      };

      nixpkgsFun = newArgs: import inputs.nixpkgs (args // newArgs);
    in
    {
      packageSets = {
        default.pkgs = nixpkgsFun { };
        unstable.pkgs = import inputs.nixpkgs-unstable args;
        x86-64-linux.pkgs = config.packageSets.default.pkgsCross.gnu64;
        x86-64-linux-content-addressed.pkgs = nixpkgsFun {
          crossSystem.config = "x86_64-unknown-linux-gnu";
          config.contentAddressedByDefault = true;
        };
      };

      checks = concatFilteredPackages availableOnHostPlatform
        ({ name, pkgs, ... }: {
          "hello-${name}" = pkgs.hello;
        })
        config.packageSets;
    };
}
```
