{
pkgs,
lib,
...
}:
let
  cfg = pkgs.callPackage ../../module/theme/font.nix {};
  inherit (lib.attrsets) attrValues;
  inherit (lib.lists) unique;
in
{
  packages = unique [

  ];
  file = /* qml */ ''
  pragma Singleton
  import Quickhsell
  import QtQuick

  Singleton {
    readonly property name: name

  }
  '';
}

