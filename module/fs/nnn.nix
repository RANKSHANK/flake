{
  user,
  config,
  lib,
  ...
}: lib.mkModule "nnn" [ "shell" ] config {
    home-manager.users.${user} = {
      programs.nnn = {
        enable = true;
      };
    };
}
