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
        defaultTimeout = toString 8000;
        borderRadius = toString 12;
        settings = builtins.mapAttrs (_: attr: lib.ternary (lib.isString attr) attr (toString attr)) {
            text-alignment = "center";
            icons = 1;
            width = 300;
            height = 110;
        };
      };
    };
}
