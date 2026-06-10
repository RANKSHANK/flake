{
  fromNpins,
  lib,
  stdenv,
  ...
}: let
  inherit (lib.strings) substring;
  src = fromNpins."klippain-shaketune";
  version = "git-${substring 8 15 src.hash}";
in stdenv.mkDerivation {
  pname = "klippain-shaketune";
  inherit src version;

  format = "other";
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/klippy/extras/
    cp -r shaketune $out/lib/klippy/extras/shaketune

    runHook postInstall
    '';

  passthru.extraPythonPackages = py: [
    py.numpy
    py.matplotlib
    py.zstandard
    py.gitpython
  ];

  meta = {
    description = "Shake&Tune Klipper input shaper and vibration analysis plugin";
    homepage = "https://github.com/Frix-x/klippain-shaketune";
    license = lib.licenses.gpl3Only;
  };
}
