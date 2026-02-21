{
  fromNpins,
  lib,
  python3,
  qt5,
  ...
}: let
  inherit (lib.attrsets) attrValues;
  inherit (lib.strings) substring;
  python = python3.withPackages (py: (attrValues {
    inherit (py)
      numpy
      matplotlib
      pyqt5
      psutil
    ;
  }));
  src = fromNpins."MZ_Flow_Temp_processor";
  version = "git-${substring 8 15 src.hash}";
in python.pkgs.buildPythonApplication rec {
  pname = "mz-flow-temp-processor";
  inherit version;
  inherit src;

  format = "other";

  dontBuild = true;
  dontWrapQtApps = true;

  nativeBuildInputs = attrValues {
    inherit python;
    inherit (qt5)
      qttools
      wrapQtAppsHook
    ;
  };

  buildInputs = attrValues {
    inherit (qt5)
      qtbase
      qtwayland
    ;
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp $src/mz_flow_temp.py $out/bin/${pname}
    chmod +x $out/bin/${pname}
    substituteInPlace $out/bin/${pname} --replace "#!/usr/bin/env python" "#!${python}/bin/python"
    substituteInPlace $out/bin/${pname} --replace "os.path.dirname(os.path.abspath(__file__))" "os.path.abspath('/tmp')"
    runHook postInstall
  '';

  preFixup = ''
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
    wrapQtApp "$out/bin/${pname}"
  '';

}
