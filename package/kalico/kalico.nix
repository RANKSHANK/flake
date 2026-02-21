{
  extraPythonPackages ? py: [],
  extraScriptPackages ? py: [],
  fromNpins,
  lib,
  makeShellWrapper,
  python3,
  stdenv,
  writeShellScript,
  writeTextFile,
  ...
}: let
  src = fromNpins."kalico";
  version = "git-${substring 8 15 src.hash}";
  inherit (lib.attrsets) attrValues;
  inherit (lib.strings) concatStringsSep substring;

in stdenv.mkDerivation rec {
  pname = "kalico";
  inherit version;
  inherit src;

  nativeBuildInputs = [
    (python3.withPackages (py: attrValues {
      inherit (py)
        cffi
      ;
    }))
    makeShellWrapper
  ];

  buildInputs = [
    (python3.withPackages (py: (attrValues {
      inherit (py)
        cffi
        greenlet
        jinja2
        markupsafe
        numpy
        python-can
        pyserial
      ;
    }) ++ (extraPythonPackages py)))
  ];

  postPatch = ''
    substituteInPlace ./klippy/chelper/__init__.py --replace-fail 'GCC_CMD = "gcc"' 'GCC_CMD = "${stdenv.cc.targetPrefix}cc"'
  '';

  buildPhase = /* bash */ ''
    runHook preBuild
    python -m compileall ./klippy
    python ./klippy/chelper/__init__.py
    runHook postBuild
  '';

  klipperPythonScripts = [
    "calibrate_shaper"
    "canbus_query"
  ];

  pythonInterpreter = python3.withPackages (py: attrValues {
    inherit (py)
      numpy
      matplotlib
    ;
  } ++ (extraScriptPackages py));

  pythonScriptWrapper = writeShellScript pname ''
    $pythonInterpreter "@out@/lib/${pname}/scripts/@script@" "$@"
  '';

  installPhase = /* bash */ ''
  runHook preInstall

  mkdir -p $out/lib/${pname}
  cp -r config docs klippy scripts $out/lib/${pname}
  cp -r ./ $out/lib/src

  chmod 755 $out/lib/${pname}/klippy/klippy.py
  echo "${version}" > $out/lib/${pname}/klippy/.version

  mkdir -p $out/bin
  makeShellWrapper $out/lib/${pname}/klippy/klippy.py $out/bin/klippy

  for script in ${concatStringsSep " " klipperPythonScripts}; do
    substitute "$pythonScriptWrapper" "$out/bin/klipper-$script" \
      --subst-var "out" \
      --subst-var-by "script" "$script.py"
    chmod 755 "$out/bin/klipper-$script"
    chmod +x "$out/lib/${pname}/scripts/$script.py"
  done


  runHook postInstall
  '';


}
