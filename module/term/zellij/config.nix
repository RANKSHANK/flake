{
  lib,
  util,
  ...
}: let
  inherit (lib.strings) concatStringsSep;
  inherit (util) genNumStrs;
in ''
  // Might as well use nix since this schema is so munted
  keybinds clear-defaults=true {
      shared_except "normal" {
          bind "Esc" { SwitchToMode "Normal"; }
      }
      normal {
          bind "Alt p" { ToggleFloatingPanes; }
          bind "Alt x" "Alt q" { CloseFocus; }
          bind "Alt e" { EditScrollback; }
          bind "Alt d" { HalfPageScrollDown; }
          bind "Alt u" { HalfPageScrollUp; }
          bind "Alt j" { ScrollDown; }
          bind "Alt k" { ScrollUp; }
          bind "Alt k" { ScrollUp; }
          bind "Alt b" {
              NewTab;
              Run "zellij" "action" "launch-plugin" "zellij:session-manager" "-i" {
                  in_place true
                  close_on_exit true
              }
          }
          ${concatStringsSep "\n        " (genNumStrs 10 ''
    bind "Alt <num>" {
        Run "zellij" "action" "go-to-tab-name" "-c" "<num>" {
            close_on_exit true
            in_place true
        }
    }'')}
      }
  }
''
