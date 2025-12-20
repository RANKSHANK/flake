{
  config,
  inputs,
  lib,
  pkgs,
  user,
  util,
  ...
}: let
  inherit (util) concatLines listTargetFilesRecursively mkModule;
in
  mkModule "ghostty" ["desktop"] {
    keybinds = [
      {
        name = "Ghostty";
        mods = ["super"];
        combo = ["return"];
        exec = "ghostty";
      }
    ];

    home-manager.users.${user} = {
      programs.ghostty = {
        enable = true;
        # package = inputs.ghostty.packages.${pkgs.system}.default;
        installVimSyntax = true;
        installBatSyntax = true;
        clearDefaultKeybinds = true;
        enableFishIntegration = config.modules.fish.enable;
        settings = {
          window-decoration = false;
          confirm-close-surface = false;
          keybind = [
            # "ctrl+backspace=text:\\x1b\\x7f"
          ];
          background-opacity = 1.0;
          custom-shader-animation = true;
          custom-shader =
            map (
              shader:
                (pkgs.writeText "ghostty-shader" (pkgs.callPackage shader {
                  inherit util config inputs;
                })).outPath
            ) (
              listTargetFilesRecursively ".nix" ./shaders
            );
        };
      };
    };
  }
