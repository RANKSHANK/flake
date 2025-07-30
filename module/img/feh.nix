{
  user,
  util,
  ...
}: let
  inherit (util) mkModule;
in
  mkModule "feh" ["desktop" "graphics"] {
    home-manager.users.${user} = {
      xdg.mimeApps.defaultApplications = {
        "feh" = [
          ".png"
          ".jpg"
          ".pnm"
          ".bmp"
          ".tiff"
        ];
      };
      programs.feh = {
        enable = true;
      };
    };
  }
