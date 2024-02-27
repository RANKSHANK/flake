{
  lib,
  config,
  user,
  ...
}: let
  smush = builtins.concatStringsSep "";

  genBind = map (keybind:
    builtins.concatStringsSep ", " (lib.flatten [
      (lib.ternary (lib.safeIsList "mods" keybind) (smush keybind.mods) "")
      (lib.ternary (lib.safeIsList "combo" keybind) (smush keybind.combo) [])
      (lib.ternary (lib.safeIsString "exec" keybind) "exec, ${keybind.exec}" "")
    ])) (builtins.filter (attr: builtins.hasAttr "combo" attr) config.keybinds);

  genBindr = lib.flatten (map (lr:
    map (keybind:
      builtins.concatStringsSep ", " (lib.flatten [
        (lib.ternary (lib.safeIsList "mods" keybind) "${smush (lib.init keybind.mods)}${lib.ternary (lib.length keybind.mods > 1) "" (lib.last keybind.mods)}, ${lib.last keybind.mods}_${lr}" "")
        (lib.ternary (lib.safeIsString "exec" keybind) "exec, ${keybind.exec}" "")
      ])) (builtins.filter (attr: !builtins.hasAttr "combo" attr) config.keybinds)) ["L" "R"]);

in lib.mkSubmodule "hyprland" config {
    home-manager.users.${user}.wayland.windowManager.hyprland.settings = {
      bindm = [
        "super, mouse:272, movewindow"
        "super, mouse:273, resizewindow"
      ];
      bind = lib.flatten [
        "super, q, killactive"
        "super, h, movefocus, l"
        "super, j, movefocus, d"
        "super, k, movefocus, u"
        "super, l, movefocus, r"
        "supershift, h,movewindow, l"
        "supershift, j,movewindow, d"
        "supershift, k,movewindow, xu"
        "supershift, l,movewindow, r"
        "superctrl, l, workspace, +1"
        "superctrl, h, workspace, -1"
        "superctrlshift, l, movetoworkspace, +1"
        "superctrlshift, h, movetoworkspace, -1"
        "super, p, pin, active"
        "super, f, togglefloating, active"

        (lib.genNumStrs 10 "super, <num>, focusworkspaceoncurrentmonitor, <num>")
        (lib.genNumStrs 10 "super, kp_<num>, focusworkspaceoncurrentmonitor, <num>")
        (lib.genNumStrs 10 "supershift, <num>, movetoworkspace, <num>")
        (lib.genNumStrs 10 "supershift, kp_<num>, movetoworkspace, <num>")
        genBind
        ", XF86AudioMute, exec, set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioStop, exec, playerctl stop"
        ", XF86AudioPrev, exec, playerctl previous"
        ", XF86AudioNext, exec, playerctl next"
      ];
      bindl = lib.flatten [
        ", code:202, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ 0"
      ];
      bindr = lib.flatten [
        ", code:202, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ 1"
        genBindr
      ];
    };
}
