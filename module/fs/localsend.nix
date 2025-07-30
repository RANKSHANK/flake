{
  lib,
  pkgs,
  util,
  ...
}: let
  inherit (lib.attrsets) attrValues;
  inherit (util) mkModule;
in
  mkModule "localsend" ["connectivity" "sync" "desktop"] {
    environment.systemPackages = attrValues {
      inherit (pkgs) localsend;
    };

    networking.firewall = {
      allowedUDPPorts = [53317];
      allowedTCPPorts = [53317];
    };
  }
