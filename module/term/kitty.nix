{
  user,
  util,
  ...
}: let
  inherit (util) mkModule;
in
  mkModule "kitty" ["desktop"] {
    home-manager.users.${user} = {
      programs.kitty = {
        enable = true;
      };
    };
  }
