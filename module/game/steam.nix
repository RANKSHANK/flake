{
  config,
  pkgs,
  lib,
  ...
}: let
    steam-desktop-patcher = lib.patchDesktopEntry pkgs pkgs.steam "steam"
        ["^Exec=steam"]
        ["Exec=PULSE_LATENCY_MS=50 mangohud steam"];

in lib.mkModule "steam" [ "desktop" "gaming" ] {

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
                        # inetutils
                        keyutils
                        libgdiplus
                        libkrb5
                        libpng
                        libpulseaudio
                        libthai
                        libunwind
                        libvorbis
                        # mono5
                        pango
                        # protontricks
                        strace
                        # winetricks
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
        gamescopeSession = {
            enable = true;
        };
        extraCompatPackages = builtins.attrValues {
          inherit (pkgs) proton-ge-bin;
        };
      };
    gamescope = {
        enable = true;
        capSysNice = false;
        args = [ "--rt" "--expose-wayland" ];
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
