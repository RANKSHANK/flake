{
  pkgs,
  config,
  inputs,
  lib,
  ...
}: lib.mkModule "blender" [ "cad" "desktop" ] {
    environment.systemPackages = builtins.attrValues {
      inherit (inputs.nix-stable.legacyPackages.${pkgs.system}) blender;
    };
}
