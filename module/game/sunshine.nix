{ config, lib, pkgs, ... }:

lib.mkModule "sunshine" [ "desktop" "gaming" "stream-host" ] {

    boot.kernelModules = [ "uinput" ];

    environment.systemPackages = builtins.attrValues {
        inherit (pkgs) sunshine;
    };

    security = {
        wrappers.sunshine  = {
            owner = "root";
            group = "root";
            capabilities = "cap_sys_admin+p";
            source = "${pkgs.sunshine}/bin/sunshine";
        };

        sudo.extraRules = [
            {
                users = [ "sunshine" ];
                commands = [ {
                    command = "ALL";
                    options = [ "NOPASSWD" ];
                } ];
            }
        ];
    };

    services.avahi.publish.userServices = true;

    systemd.user.services.sunshine = {
        description = "Sunshine Streaming Server";
        wantedBy = [ "graphincal-session.target" ];
        startLimitIntervalSec = 500;
        startLimitBurst = 5;
        partOf = [ "graphical-session.target" ];
        wants = [ "graphical-session.target" ];
        after = [ "graphical-session.target" ];

        serviceConfig = let
            conf = pkgs.writeTextDir "config/sunshine.conf" ''
            origin_web_ui_allowed=wan
            '';
        in {
            ExecStart = "${config.security.wrapperDir}/sunshine ${conf}/config/sunshine.conf";
            Restart = "on-failure";
            RestartSec = "5s";
        };
    };

    users.users.sunshine = {
        isNormalUser = true;
        home = "/tmp/sunshine";
        description = "Sunshine Streaming Server";
        extraGroups = [
            "wheel"
            "networkmanager"
            "input"
            "video"
            "sound"
        ];
        hashedPassword= "!";
    };
}
