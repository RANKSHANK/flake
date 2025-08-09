{
  config,
  lib,
  pkgs,
  user,
  util,
  ...
}: let
  inherit (lib.meta) getExe;
  inherit (lib.modules) mkForce;
  inherit (lib.options) mkOption;
  inherit (lib.types) listOf str;
  inherit (util) concatLines mkModule;
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
      xdg.configFile."zellij/layouts/startup.kdl".text = pkgs.callPackage ./layouts/startup.nix {
        inherit config util;
      };
      xdg.configFile."zellij/config.kdl".text = pkgs.callPackage ./config.nix {inherit util;};
    };
  }
