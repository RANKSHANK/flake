{
  config,
  pkgs,
  user,
  util,
  ...
}: let
  inherit (util) concatLines mkModule;
in
  mkModule "kitty" ["desktop"] {
    home-manager.users.${user} = {
      programs.kitty = {
        enable = true;
        settings = {
          confirm_os_window_close = -1;
        };
      };
    };
  }
