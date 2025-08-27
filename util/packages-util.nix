{
  pkgs,
  lib,
  ...
}: let
  inherit (pkgs) callPackage;
in {

  # Currying friendly callPackage.
  callPkg = specialArgs: pkg: callPackage pkg specialArgs;
}
