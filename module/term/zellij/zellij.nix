{
  user,
  config,
  lib,
  ...
}: lib.mkModule "zellij" [ "shell" ] config {
    home-manager.users.${user} = {
      programs.zellij = {
        enable = true;
        enableFishIntegration = true;
        settings = {
          simplified_ui = true;
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
      # This is terrible. wtf even is kdl
      xdg.configFile."zellij/config.kdl".text = builtins.readFile ./config.kdl;
    };
}
