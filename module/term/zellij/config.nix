lib: ''
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
        ${builtins.concatStringsSep "\n" (lib.genNumStrs 10 ''bind "Alt <num>" { GoToTab <num>; }'')}
    }
}
''
