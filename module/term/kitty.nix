{ config, lib, user, ... }:

lib.mkModule "kitty" [ "desktop" ] config {
    keybinds = [
      {
        name = "Kitty";
        mods = ["super"];
        combo = ["return"];
        exec = "kitty";
      }
    ];

    home-manager.users.${user} = {
        programs.kitty = {
            enable = true;
        };
    };
}
