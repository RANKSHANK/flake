{
  config,
  user,
  lib,
  ...
}: lib.mkModule "btop" [ "shell" ] {
    home-manager.users.${user}.programs.btop = {
        enable = true;
        settings = {
            vim_keys = true;
        };
    };
}
