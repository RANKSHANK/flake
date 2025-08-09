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
      hyprfocus
      ;
    inherit
      (inputs.hypr-easymotion.packages.${pkgs.system})
      hyprland-easymotion
      ;
  }
