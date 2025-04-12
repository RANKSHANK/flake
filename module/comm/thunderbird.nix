{ lib, config, pkgs, user, ... }:

lib.mkModule "thunderbird" [ "desktop" "communication" ] {
    environment.systemPackages = builtins.attrValues {
        inherit (pkgs) thunderbird;
    };
    # home-manager.users.${user} = {
    #     programs.thunderbird.enable = true;
    # };
}
