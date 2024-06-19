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
                    inherit (pkgs)
                        at-spi2-atk
                        fmodex
                        glxinfo
                        gtk3
                        gtk3-x11
                        harfbuzz
                        icu
                        inetutils
                        keyutils
                        libgdiplus
                        libkrb5
                        libpng
                        libpulseaudio
                        libthai
                        libunwind
                        libvorbis
                        mono5
                        pango
                        strace
                        zlib
                        ;
                    inherit (pkgs.stdenv.cc.cc)
                        lib;
                    inherit (pkgs.xorg)
                        libXcursor
                        libXi
                        libXinerama
                        libXScrnSaver;
                };
        };
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
        localNetworkGameTransfers.openFirewall = true;
        # gamescopeSession = {
        #     enable = true;
        # };
        extraCompatPackages = builtins.attrValues {
          inherit (pkgs) proton-ge-bin;
        };
      };
    gamescope = {
        enable = true;
        capSysNice = false;
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
