{ user, config, lib, ... }:

lib.mkModule "zellij" [ "shell" ] config {
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
        ZELLIJ_AUTO_EXIT = "true";
      };
      xdg.configFile."zellij/layouts" = {
        source = ./layouts;
      };
      xdg.configFile."zellij/config.kdl".text = import ./config.nix lib;
    };
}
