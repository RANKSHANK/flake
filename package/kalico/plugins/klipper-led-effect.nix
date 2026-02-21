{
  fromNpins,
  lib,
  stdenv,
  ...
}: let
  inherit (lib.attrsets) attrValues;
  inherit (lib.strings) substring;
  src = fromNpins."klipper-led_effect";
  version = "git-${substring 8 15 src.hash}";
in stdenv.mkDerivation {
  pname = "klipper-led-effect";
  inherit src version;

  format = "other";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib/klippy/extras
    cp $src/src/led_effect.py $out/lib/klippy/extras/
    runHook postInstall
  '';

}
