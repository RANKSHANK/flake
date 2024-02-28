{ inputs, config, lib, user, pkgs, ... }:

lib.mkModule "anyrun" [ "desktop" "wayland" ] config {

    keybinds = [
      {
        name = "AnyRun";
        mods = ["super"];
        exec = "pkill anyrun || anyrun";
      }
    ];

    nix.settings = {
        substituters = [
            "https://anyrun.cachix.org"
        ];

        trusted-public-keys = [
            "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
        ];
    };

    home-manager.users.${user} = {
        imports = [
            inputs.anyrun.homeManagerModules.default
        ];
        programs.anyrun = {
            enable = true;
            config = {
                plugins = builtins.attrValues {
                    inherit (inputs.anyrun.packages.${pkgs.system})
                        applications
                        randr
                        rink
                        shell
                        symbols;
                };
                hidePluginInfo = true;
            };
        };
    };

}
