{
  lib,
  config,
  user,
  util,
  ...
}: let
  inherit (lib.attrsets) hasAttr;
  inherit (lib.strings) concatStringsSep;
  inherit (lib.lists) filter flatten init length last;
  inherit (util) genNumStrs safeIsList safeIsString ternary;
  smush = concatStringsSep "";

  genBind = map (keybind:
    concatStringsSep ", " (flatten [
      (ternary (safeIsList "mods" keybind) (smush keybind.mods) "")
      (ternary (safeIsList "combo" keybind) (smush keybind.combo) [])
      (ternary (safeIsString "exec" keybind) "exec, ${keybind.exec}" "")
    ])) (filter (attr: hasAttr "combo" attr) config.keybinds);

  genBindr = flatten (map (lr:
    map (keybind:
      concatStringsSep ", " (flatten [
        (ternary (safeIsList "mods" keybind) "${smush (init keybind.mods)}${ternary (length keybind.mods > 1) "" (last keybind.mods)}, ${last keybind.mods}_${lr}" "")
        (ternary (safeIsString "exec" keybind) "exec, ${keybind.exec}" "")
      ])) (filter (attr: !hasAttr "combo" attr) config.keybinds)) ["L" "R"]);
in {
  home-manager.users.${user}.wayland.windowManager.hyprland = {
    settings = {
      bindm = [
        "super, mouse:272, movewindow"
        "super, mouse:273, resizewindow"
      ];
      bind = flatten [
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

        (genNumStrs 10 "super, <num>, focusworkspaceoncurrentmonitor, <num>")
        (genNumStrs 10 "super, kp_<num>, focusworkspaceoncurrentmonitor, <num>")
        (genNumStrs 10 "supershift, <num>, movetoworkspace, <num>")
        (genNumStrs 10 "supershift, kp_<num>, movetoworkspace, <num>")
        genBind
        ", XF86AudioMute, exec, set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioStop, exec, playerctl stop"
        ", XF86AudioPrev, exec, playerctl previous"
        ", XF86AudioNext, exec, playerctl next"
        ", scroll_lock, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
      ];
      # bindil = flatten [
      #   ", scroll_lock, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ 0"
      # ];
      bindirl = flatten [
        # ", scroll_lock, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ 1"
        genBindr
      ];
    };
  };
}
