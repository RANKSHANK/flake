{
  pkgs,
  util,
  ...
}: let
  inherit (util) mkModule fromNpins;
in
  mkModule "prusa" ["desktop" "cad"] {
    environment.systemPackages = [
      (pkgs.prusa-slicer.overrideAttrs (orig: {
        src = (fromNpins ../../../package/packages.json)."PrusaSlicer";
        doCheck = false;
      }))
    ];
  }
