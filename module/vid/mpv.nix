{
  lib,
  pkgs,
  user,
  util,
  ...
}: let
  inherit (lib.attrsets) attrValues;
  inherit (util) mkModule;
in
  mkModule "video" ["desktop" "media"] {
    home-manager.users.${user} = {
      programs.mpv = {
        enable = true;
        scripts = attrValues {
          inherit (pkgs.mpvScripts) mpris quality-menu sponsorblock autoload thumbnail;
        };
      };
    };
  }
