{
  config,
  inputs,
  lib,
  user,
  util,
  ...
}: let
  inherit (lib.lists) flatten foldl' zipListsWith;
  inherit (util) mkModule ternary;
in
  mkModule "xremap" ["desktop"] {
    imports = [inputs.xremap.nixosModules.default];

    services.xremap = {
      serviceMode = "user";
      userName = user;
      withHypr = config.modules.hyprland.enable;
      # watch = true;
      # debug = true;

      config = {
        # keypress_delay_ms = 25;
        modmap = let
          swap = first: second: {
            "KEY_${first}" = "KEY_${second}";
            "KEY_${second}" = "KEY_${first}";
          };
          qwerty = [
            # Top row
            "Q"
            "W"
            "E"
            "R"
            "T"
            "Y"
            "U"
            "I"
            "O"
            "P"
            # Home row
            "A"
            "S"
            "D"
            "F"
            "G"
            "H"
            "J"
            "K"
            "L"
            "SEMICOLON"
            # Bottom row
            "Z"
            "X"
            "C"
            "V"
            "B"
            "N"
            "M"
          ];
          # Modded QWERTY based on ESDF for movement
          qwerty-esdf = [
            # Top row
            "Q"
            "E"
            "W"
            "R"
            "T"
            "Y"
            "U"
            "I"
            "O"
            "P"
            # Home row
            "F"
            "A"
            "S"
            "D"
            "G"
            "H"
            "J"
            "K"
            "L"
            "SEMICOLON"
            # Bottom row
            "Z"
            "X"
            "C"
            "V"
            "B"
            "N"
            "M"
          ];
          colemak = [
            # Top row
            "Q"
            "W"
            "F"
            "P"
            "G"
            "J"
            "L"
            "U"
            "Y"
            "SEMICOLON"
            # Home row
            "A"
            "R"
            "S"
            "T"
            "D"
            "H"
            "N"
            "E"
            "I"
            "O"
            # Bottom row
            "Z"
            "X"
            "C"
            "V"
            "B"
            "K"
            "M"
          ];
          convertLayout = from: to:
            zipListsWith (og: new:
              ternary (og == new) {} {
                "KEY_${og}" = "KEY_${new}";
              })
            from
            to;
          combine = list: foldl' (acc: attr: acc // attr) {} (flatten list);
        in [
          {
            name = "WASD";
            remap = combine [
              (convertLayout colemak qwerty-esdf)
            ];
            window.only = [
              "/Moonlighter/"
              "/Cauldron/"
              "/(Going Under)/"
            ];
          }
        ];
      };
    };
  }
