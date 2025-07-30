{
  user,
  util,
  ...
}: let
  inherit (util) mkModule;
in
  mkModule "btop" ["shell"] {
    home-manager.users.${user}.programs.btop = {
      enable = true;
      settings = {
        vim_keys = true;
      };
    };
  }
