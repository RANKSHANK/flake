{
  pkgs,
  config,
  lib,
  ...
}: let
  snip = with pkgs;
    writeShellScriptBin "snip" ''
      #!/usr/bin/env bash
      file=~/tmp/screenshot_$(date +'%H:%M:%S_%d%B%Y').png
      ${grim}/bin/grim -g "$(${slurp}/bin/slurp)" - | ${swappy}/bin/swappy -f - -o $file
      if command -v notify-send &> /dev/null; then
          title="Snipped"
          body="Saved to $file"
          notify-send "$title" "$body"
      fi
    '';
in
  lib.mkModule "grim" ["desktop" "wayland"] {
    keybinds = [
      {
        name = "Screen Capture";
        mods = ["super"];
        combo = ["s"];
        exec = "${lib.getExe' snip "snip"}";
      }
    ];
  }
