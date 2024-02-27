{
  config,
  user,
  lib,
  ...
}: lib.mkModule "btop" [ "shell" ] config {
    home-manager.users.${user}.programs.btop = {
        enable = true;
        settings = {
            vim_keys = true;
        };
    };
}
