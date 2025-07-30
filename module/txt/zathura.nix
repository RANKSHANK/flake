{
  lib,
  user,
  util,
  ...
}: let
  inherit (util) mkModule;
in
  mkModule "zathura" ["desktop" "office"] {
    home-manager.users.${user} = {
      programs.zathura = {
        enable = true;
        options = {
          selection-clipboard = "clipboard";
          recolor = lib.mkForce true;
        };
      };
    };
  }
