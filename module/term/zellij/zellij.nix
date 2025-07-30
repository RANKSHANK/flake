{
  lib,
  pkgs,
  user,
  util,
  ...
}: let
  inherit (lib.modules) mkForce;
  inherit (util) mkModule;
in
  mkModule "zellij" ["shell"] {
    home-manager.users.${user} = {
      programs.zellij = {
        enable = true;
        enableFishIntegration = true;
        settings = {
          default_layout = "startup";
          pane_frames = false;
        };
      };
      home.sessionVariables = {
        # ZELLIJ_AUTO_ATTACH = "true";
        ZELLIJ_AUTO_EXIT = mkForce "true";
      };
      xdg.configFile."zellij/layouts" = {
        source = ./layouts;
      };
      xdg.configFile."zellij/config.kdl".text = pkgs.callPackage ./config.nix {inherit util;};
    };
  }
