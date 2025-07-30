{
  user,
  util,
  ...
}: let
  inherit (util) mkModule;
in
  mkModule "alacritty" ["desktop"] {
    home-manager.users.${user} = {
      programs.alacritty = {
        enable = true;
      };
    };
  }
