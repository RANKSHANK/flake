{
  user,
  config,
  lib,
  ...
}: lib.mkModule "udiskie" [] {
    home-manager.users.${user} = {
      services.udiskie = {
        enable = true;
        automount = true;
        notify = true;
        settings = {};
      };
    };
}
