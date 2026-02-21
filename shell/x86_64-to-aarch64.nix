{
  pkgs ? import <nixpkgs> {
    localSystem = "x86_64-linux";
    crossSystem = "aarch64-linux";

  },
}:
pkgs.callPackage (
  {
    mkShell,
  }:
  mkShell {}
) { }
