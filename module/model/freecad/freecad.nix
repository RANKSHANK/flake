{
  config,
  inputs,
  lib,
  pkgs,
  user,
  util,
  ...
}: let
  inherit (lib.attrsets) attrValues;
  inherit (pkgs) callPackage;
  inherit (util) mkModule;
  args = { inherit config inputs util lib; };
in
  mkModule "freecad" ["desktop" "cad"] {
    environment.systemPackages = attrValues {
      inherit (inputs.nix-stable.legacyPackages.${pkgs.system}) freecad;
    };
    home-manager.users.${user}.xdg.dataFile = {
      "FreeCAD/Mod/Stylix/Stylix/Stylix.cfg".text = callPackage ./cfg.nix args;
      "FreeCAD/Mod/Stylix/Stylix/Stylix.qss".text = callPackage ./minimal-style.nix args;
      "FreeCAD/Mod/Stylix/package.xml".text = callPackage ./package.nix args;
    };
  }
