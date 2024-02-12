{ config, lib, user, ... }:

lib.mkModule "alacritty" [ "desktop" ] config {

    home-manager.users.${user} = {
        programs.alacritty = {
            enable = true;
        };
    };
}
