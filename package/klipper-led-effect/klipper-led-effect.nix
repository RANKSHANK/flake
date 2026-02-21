{
  fromNpins,
  lib,
  python3,
  ...
}: let
  inherit (lib.attrsets) attrValues;
  inherit (lib.strings) substring;
  python = python3.withPackages (py: (attrValues {
  }));
  src = fromNpins."klipper-led_effect";
  version = "git-${substring 8 15 src.hash}";
in python.pkgs.buildPythonApplication rec {
  pname = "klipper-led-effect";
  inherit version;
  inherit src;

  format = "other";

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp $src/src/led_effect.py $out/bin/${pname}.py
    runHook postInstall
  '';

}
