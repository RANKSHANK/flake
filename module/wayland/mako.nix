{
  pkgs,
  user,
  config,
  lib,
  ...
}: lib.mkModule "mako" [ "desktop" "wayland" ] {
    environment.systemPackages = builtins.attrValues {
      inherit (pkgs) mako libnotify;
    };

    home-manager.users.${user} = {
      services.mako = {
        enable = true;
        defaultTimeout = 8000;
        borderRadius = 12;
        extraConfig = ''
          []
          text-alignment=center
          icons=1
          width=300
          height=110
        '';
      };
    };
}
