{
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (lib.attrsets) attrValues;
in
  attrValues {
    inherit
      (inputs.hyprland-plugins.packages.${pkgs.system})
      ;
  }
