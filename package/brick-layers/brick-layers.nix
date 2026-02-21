{
  fromNpins,
  lib,
  python3,
  stdenv,
  ...
}: let
  inherit (lib.attrsets) attrValues;
  inherit (lib.strings) substring;
  python = python3.withPackages (py: (attrValues {
    # inherit (py)
    # ;
  }));
  src = fromNpins."BrickLayers";
  version = "git-${substring 8 15 src.hash}";
in stdenv.mkDerivation rec {
  pname = "brick-layers";
  inherit version;
  inherit src;

  format = "other";

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp $src/bricklayers.py $out/bin/${pname}
    chmod +x $out/bin/${pname}
    substituteInPlace $out/bin/${pname} --replace "#!/usr/bin/env python" "#!${python}/bin/python"
    substituteInPlace $out/bin/${pname} --replace "error_log_path = os.path.join(script_dir, error_log)" "error_log_path = os.path.join(os.path.abspath('/tmp'), '${pname}.log')"
    substituteInPlace $out/bin/${pname} --replace "error_log_path = os.path.join(script_dir, error_log)" "error_log_path = os.path.join(os.path.abspath('/tmp'), '${pname}.log')"
    substituteInPlace $out/bin/${pname} --replace "log_file_path = os.path.join(script_dir, \"bricklayers_log.txt\")" "log_file_path = os.path.join(os.path.abspath('/tmp'), '${pname}.log')"
    runHook postInstall
  '';

}
