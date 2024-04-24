{
  lib,
  config,
  user,
  ...
}: lib.mkSubmodule "hyprland" config {
    home-manager.users.${user}.wayland.windowManager.hyprland.settings.monitor = lib.flatten [
      (builtins.map (
        monitor:
          builtins.concatStringsSep "" [
            (monitor.connection)
            ", "
            (toString monitor.horizontal)
            "x"
            (toString monitor.vertical)
            (lib.ternary (lib.safeIsInt "refreshRate" monitor) "@${toString monitor.refreshRate}" "")
            ", "
            (lib.ternary (lib.safeIsInt "xPos" monitor) "${toString (monitor.horizontal * monitor.xPos)}" "0")
            "x"
            (lib.ternary (lib.safeIsInt "yPos" monitor) (toString (monitor.vertical * monitor.yPos)) "0")
            ", "
            (lib.ternary (lib.safeIsFloat "scale" monitor) (toString monitor.scale) "1")
          ]
      ) (builtins.attrValues config.monitors))
      ", highrr, auto, 1"
    ];
}
