{
  pkgs,
  user,
  config,
  lib,
  ...
}:
lib.mkModule "mako" ["desktop" "wayland"] {
  environment.systemPackages = builtins.attrValues {
    inherit (pkgs) mako libnotify;
  };

  home-manager.users.${user} = {
    services.mako = {
      enable = true;
      settings = builtins.mapAttrs (_: attr: lib.ternary (lib.isString attr) attr (toString attr)) {
        default-timeout = toString 8000;
        border-radius = toString 12;
        text-alignment = "center";
        icons = 1;
        width = 300;
        height = 110;
      };
    };
  };
}
