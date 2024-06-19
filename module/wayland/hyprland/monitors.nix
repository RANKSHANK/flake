{
  lib,
  config,
  user,
  ...
}: lib.mkSubmodule "hyprland" config {
    home-manager.users.${user}.wayland.windowManager.hyprland.settings.monitor = let
        sortedMonitors = (builtins.sort (first: second: (lib.ternary (lib.safeIsInt "xPos" first) first.xPos 0) < (lib.ternary (lib.safeIsInt "xPos" second) second.xPos 0)) (builtins.attrValues config.monitors));

        xPoses = (lib.foldl' (acc: monitor:
            lib.ternary ((builtins.length acc) > 0) (
                acc ++ [ ((lib.last acc) + monitor.horizontal) ]
            ) [ 0 monitor.horizontal ]
        ) [] sortedMonitors);

    in lib.flatten [
      (lib.imap0 (
        idx: monitor:
          builtins.concatStringsSep "" [
            (monitor.connection)
            ", "
            (toString monitor.horizontal)
            "x"
            (toString monitor.vertical)
            (lib.ternary (lib.safeIsInt "refreshRate" monitor) "@${toString monitor.refreshRate}" "")
            ", "
            (toString (builtins.elemAt xPoses idx))
            "x"
            (lib.ternary (lib.safeIsInt "yPos" monitor) (toString (monitor.vertical * monitor.yPos)) "0")
            ", "
            (lib.ternary (lib.safeIsFloat "scale" monitor) (toString monitor.scale) "1")
          ]
      ) sortedMonitors)
      ", highrr, auto, 1"
    ];
}
