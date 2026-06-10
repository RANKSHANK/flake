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

  combinedPythonPackages = py: (flatten [
    (extraPythonPackages py)
    (map (plugin:
      if hasAttr "extraPythonPackages" plugin then
        (plugin.extraPythonPackages py)
      else
        []
    ) plugins)
  ]);

  python = python3.withPackages (py: (
    attrValues {
      inherit (py)
        cffi
        greenlet
        jinja2
        markupsafe
        numpy
        python-can
        pyserial
      ;
    } ++ combinedPythonPackages py
  ));
  kalico = stdenv.mkDerivation rec {
    pname = "kalico";
    inherit version;
    inherit src;

    nativeBuildInputs = [
      python
      makeShellWrapper
    ];

    buildInputs = [
      python
    ];

    postPatch = ''
      substituteInPlace ./klippy/chelper/__init__.py --replace-fail 'GCC_CMD = "gcc"' 'GCC_CMD = "${stdenv.cc.targetPrefix}cc"'
    '';

    buildPhase = /* bash */ ''
      runHook preBuild

      ${concatStringsSep "\n" (map (plugin: ''
        if [ -d ${plugin}/lib/klippy/extras ]; then
          cp -R --no-preserve=mode,ownership ${plugin}/lib/klippy/extras/. ./klippy/extras/
        fi
        if [ -d ${plugin}/lib/klippy/plugins ]; then
          cp -R --no-preserve=mode,ownership ${plugin}/lib/klippy/plugins/. ./klippy/plugins/
        fi
      '') plugins)}

      chmod -R u+rwX ./klippy/extras ./klippy/plugins
      find ./klippy -type d -name __pycache__ -prune -exec rm -rf {} +

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
    makeShellWrapper ${python}/bin/python $out/bin/klippy \
      --add-flags "$out/lib/${pname}/klippy/klippy.py"

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

