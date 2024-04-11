{
  config,
  pkgs,
  lib,
  ...
}: lib.mkModule "steam" [ "desktop" "gaming" ] config {

    environment.systemPackages = builtins.attrValues {
      inherit (pkgs) steamcmd;
    };

    programs = {
      steam = {
        enable = true;
        package = pkgs.steam.override {
            extraLibraries = pkgs: builtins.attrValues {
                    inherit (pkgs) keyutils libkrb5 libpng libpulseaudio libvorbis;
                    inherit (pkgs.stdenv.cc.cc) lib;
                    inherit (pkgs.xorg) libXcursor libXi libXinerama libXScrnSaver;
                };
        };
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = false;
        gamescopeSession.enable = true;
        extraCompatPackages = builtins.attrValues {
          inherit (pkgs) proton-ge-bin;
        };
      };
      gamemode.enable = true;
    };

    hardware.steam-hardware.enable = true;

    nixpkgs.config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "steam"
        "steam-original"
        "steam-runtime"
      ];
}
