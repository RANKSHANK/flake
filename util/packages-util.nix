{
  pkgs,
  lib,
  ...
}: let
  inherit (pkgs) callPackage writeTextFile;
in {

  # Currying friendly callPackage.
  callPkg = specialArgs: pkg: callPackage pkg specialArgs;

  genUdevRules = name: priority: text: writeTextFile {
    inherit name text;
    destination = "/etc/udev/rules.d/${toString priority}-${name}.rules";
  };
}
