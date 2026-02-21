{
  fromNpins,
  lib,
  util,
  makeShellWrapper,
  python3,
  stdenv,
  writeShellScript,
  callPackage,
  extraPythonPackages ? _: [],
  extraScriptPackages ? _: [],
  plugins ? [],
  ...
}: let
  src = fromNpins."kalico";
  version = "git-${substring 8 15 src.hash}";
  inherit (builtins) readDir;
  inherit (lib.attrsets) attrValues hasAttr mapAttrs' nameValuePair;
  inherit (lib.lists) flatten;
  inherit (lib.strings) concatStringsSep substring removeSuffix;
  combinedPythonPackages = flatten [
    (extraPythonPackages python3.pythonPackages)
    (map (plugin:
      if hasAttr "extraPythonPackages" plugin then
        (plugin.extraPythonPackages python3.pythonPackages)
      else
        []
    ) plugins)
  ];
  kalico = stdenv.mkDerivation rec {
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
      combinedPythonPackages
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
      }) ++ combinedPythonPackages))
    ];

    postPatch = ''
      substituteInPlace ./klippy/chelper/__init__.py --replace-fail 'GCC_CMD = "gcc"' 'GCC_CMD = "${stdenv.cc.targetPrefix}cc"'
    '';

    buildPhase = /* bash */ ''
      runHook preBuild
      python -m compileall ./klippy
      python ./klippy/chelper/__init__.py

      ${concatStringsSep "\n" (map (plugin: ''
        [ -d ${plugin}/lib/klippy/extras ] && cp -r ${plugin}/lib/klippy/extras  ./klippy
        [ -d ${plugin}/lib/klippy/plugins ] && cp -r ${plugin}/lib/klippy/plugins ./klippy
      '') plugins)}
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
  };
 in
kalico // {
   kalicoPlugins = mapAttrs' (name: _: nameValuePair
     (removeSuffix ".nix" name)
     (callPackage ./plugins/${name} {
       inherit util lib kalico;
       fromNpins = util.fromNpins ./plugins.json;
     })
   ) (readDir ./plugins);
}

