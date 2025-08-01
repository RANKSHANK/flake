{
  user,
  util,
  ...
}: let
  inherit (util) mkModule;
in
  mkModule "starship" ["shell"] {
    home-manager.users.${user} = {
      programs.starship = {
        enable = true;
        settings = {
          git_metrics.disabled = false;
        };
      };
    };
  }
