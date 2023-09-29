{ lib, ... }: {
  _module.args.package-sets-lib = import ../lib { inherit lib; };
}
