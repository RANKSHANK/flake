{
  pkgs,
  lib,
  util,
  ...
}: let
  inherit (lib.attrsets) attrValues;
  inherit (lib.lists) elem;
  inherit (util) mkModule;
in
  mkModule "steam" ["desktop" "gaming"] {
    environment.systemPackages = attrValues {
      inherit (pkgs) steamcmd;
    };

    programs = {
      steam = {
        enable = true;
        package = pkgs.steam.override {
          extraLibraries = pkgs:
            attrValues {
              inherit
                (pkgs)
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
              inherit
                (pkgs.stdenv.cc.cc)
                lib
                ;
              inherit
                (pkgs.xorg)
                libXcursor
                libXi
                libXinerama
                libXScrnSaver
                ;
            };
        };
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
        localNetworkGameTransfers.openFirewall = true;
        gamescopeSession = {
          enable = true;
        };
        extraCompatPackages = attrValues {
          inherit (pkgs) proton-ge-bin;
        };
      };
      gamescope = {
        enable = true;
        capSysNice = false;
        args = ["--rt" "--expose-wayland"];
      };
      gamemode.enable = true;
    };

    hardware.steam-hardware.enable = true;

    nixpkgs.config.allowUnfreePredicate = pkg:
      elem (lib.getName pkg) [
        "steam"
        "steam-original"
        "steam-runtime"
      ];
  }
