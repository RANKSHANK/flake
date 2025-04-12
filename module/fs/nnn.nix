{
  user,
  config,
  lib,
  ...
}: lib.mkModule "nnn" [ "shell" ] {
    home-manager.users.${user} = {
      programs.nnn = {
        enable = true;
      };
    };
}
