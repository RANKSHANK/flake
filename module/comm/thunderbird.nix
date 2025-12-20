{
  pkgs,
  user,
  util,
  ...
}: let
  inherit (builtins) attrValues;
  inherit (util) mkModule;
in
  mkModule "thunderbird" ["desktop" "communication"] {
    home-manager.users.${user} = {
      programs.thunderbird = {
        enable = true;
        profiles.${user} = {
          isDefault = true;

        };

      };

    };

    environment.systemPackages = attrValues {
      inherit (pkgs) protonmail-bridge-gui;
    };
  }
