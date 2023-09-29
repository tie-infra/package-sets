{
  description = ''
    A module for flake-parts to evaluate multiple Nixpkgs instances per system.
  '';
  outputs = _:
    let flakeModule = import ./flake-module.nix; in {
      inherit flakeModule;
      flakeModules.default = flakeModule;
    };
}
