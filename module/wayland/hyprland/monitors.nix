{
  lib,
  config,
  user,
  util,
  ...
}: let
  inherit (lib.attrsets) attrValues;
  inherit (lib.lists) elemAt flatten foldl' imap0 last length sort;
  inherit (lib.strings) concatStringsSep;
  inherit (util) safeIsInt safeIsFloat ternary;
in {
  home-manager.users.${user}.wayland.windowManager.hyprland.settings.monitor = let
    sortedMonitors = sort (first: second: (ternary (safeIsInt "xPos" first) first.xPos 0) < (ternary (safeIsInt "xPos" second) second.xPos 0)) (attrValues config.monitors);

    xPoses =
      foldl' (
        acc: monitor:
          ternary ((length acc) > 0) (
            acc ++ [((last acc) + monitor.horizontal)]
          ) [0 monitor.horizontal]
      ) []
      sortedMonitors;
  in
    flatten [
      (imap0 (
          idx: monitor:
            concatStringsSep "" [
              (monitor.connection)
              ", "
              (toString monitor.horizontal)
              "x"
              (toString monitor.vertical)
              (ternary (safeIsInt "refreshRate" monitor) "@${toString monitor.refreshRate}" "")
              ", "
              (toString (elemAt xPoses idx))
              "x"
              (ternary (safeIsInt "yPos" monitor) (toString monitor.yPos) "0")
              ", "
              (ternary (safeIsFloat "scale" monitor) (toString monitor.scale) "1")
            ]
        )
        sortedMonitors)
      ", highrr, auto, 1"
    ];
}
