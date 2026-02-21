{
  pkgs,
  lib,
  ...
}: let
  inherit (lib.attrsets) attrValues;
in
  pkgs.mkShell "klipper-firmware" {
    packages = attrValues {
      inherit (pkgs)
        gcc-arm-embedded
        bintools-unwrapped
        libffi
        libusb1
        avrdude
        stm32-flash
        pkg-confg
        wxGTK
      ;
      inherit (pkgs.pkgsCross.avr.stdenv) cc;
      python = pkgs.python3.withPackages (py: attrValues {
        inherit (py)
          pyserial
        ;
      });

    };
  }
