{
  user,
  util,
  ...
}: let
  inherit (util) mkModule;
in
  mkModule "nnn" ["shell"] {
    home-manager.users.${user} = {
      programs.nnn = {
        enable = true;
      };
    };
  }
