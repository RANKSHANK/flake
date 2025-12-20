{
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (lib.attrsets) attrValues;
  inherit (pkgs.stdenv.hostPlatform) system;
in
  attrValues {
    inherit
      (inputs.hyprland-plugins.packages.${system})
      hyprfocus
      ;
    # inherit
    #   (inputs.hypr-easymotion.packages.${system})
    #   hyprland-easymotion
    #   ;
    inherit
      (inputs.hypr-darkwindow.packages.${system})
      Hypr-DarkWindow
      ;
  }
