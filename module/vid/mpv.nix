{
  lib,
  config,
  pkgs,
  user,
  ...
}:
lib.mkModule "video" ["desktop" "media"] {
  home-manager.users.${user} = {
    programs.mpv = {
      enable = true;
      scripts = builtins.attrValues {
        inherit (pkgs.mpvScripts) mpris quality-menu sponsorblock autoload thumbnail;
      };
    };
  };
}
