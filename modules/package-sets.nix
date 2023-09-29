{ lib, flake-parts-lib, ... }:
let
  inherit (flake-parts-lib) mkPerSystemOption;

  packageSetModule = { name, ... }: {
    options = {
      name = lib.mkOption {
        type = lib.types.str;
        default = name;
        description = lib.mdDoc ''
          Name of the package set.
        '';
      };
      pkgs = lib.mkOption {
        type = lib.types.pkgs;
        example = lib.literalExpression ''
          import inputs.nixpkgs { inherit system; }
        '';
        description = lib.mkDoc ''
          Nixpkgs package set evaluation.
        '';
      };
    };
  };
in
{
  options.perSystem = mkPerSystemOption ({ config, ... }: {
    options = {
      packageSets = lib.mkOption {
        type = lib.types.lazyAttrsOf (lib.types.submodule packageSetModule);
        default = { };
        example = lib.literalExpression ''
          {
            default.pkgs = import inputs.nixpkgs {
              localSystem = system;
            };
          }
        '';
        description = lib.mdDoc ''
          All package set definitions.
        '';
      };
    };
  });
}
