{...}: {
  pkgs,
  user,
  config,
  lib,
  ...
}: let
  track = pkgs.writeShellScriptBin "track" ''
    #!/usr/bin/env bash
    start=$(date +%s)
    $@;
    notify-send "$@ has completed after $(echo `expr $(date +%s) - $start`)s"
  '';
  open_term = pkgs.writeShellScriptBin "open_term" ''
    #!/usr/bin/env bash
    if [[-n "$TERMINAL" ]]; then
      $Terminal &
      if [[ $? -eq 0 ]]; then
        exit 0
      fi
    notify-send "Default terminal $TERMINAL failed to launch, testing known fallbacks."
    fi
    terminals=( "alacritty" "wezterm" "kitty" "gnome-terminal" "konsole" "xfce4-terminal")
    for terminal in "''${terminals[@]}"; do
      $terminal &
      if [[ $? -eq 0 ]]; then
        exit 0
      fi
    done
    notify-send "Failed to launch backup terminals, switch to TTY"
    exit 1
  '';
in {
  config = lib.mkIfEnabled "script.default" config {
    environment.systemPackages = [
      track
      open_term
    ];

    # shared.keybinds = [
    #   "L-t=open_term"
    # ];
  };
}
