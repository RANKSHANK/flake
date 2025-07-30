{
  user,
  util,
  ...
}: let
  inherit (util) mkModule;
in
  mkModule "sudo" ["shell"] {
    users.users.${user}.extraGroups = [
      "wheel"
    ];
    security.sudo.extraConfig = ''
      Defaults lecture = never
    '';
  }
