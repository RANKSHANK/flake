{ config, lib, user, ... }:

lib.mkModule "ghostty" [ "desktop" ] {
    # keybinds = [
    #   {
    #     name = "Ghostty";
    #     mods = ["super"];
    #     combo = ["return"];
    #     exec = "ghostty";
    #   }
    # ];

    home-manager.users.${user} = {
        programs.ghostty = {
            enable = true;
            installVimSyntax = true;
            clearDefaultKeybinds = true;
            enableFishIntegration = config.modules.fish.enable;
            settings = {
                window-decoration = false;
                confirm-close-surface = false;
            };

        };
    };
}

