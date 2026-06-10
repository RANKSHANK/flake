{
  fromNpins,
  lib,
  stdenv,
  ...
}: let
  inherit (lib.attrsets) attrValues;
  inherit (lib.strings) substring;
  src = fromNpins."cartographer3d-plugin";
  pname = "cartographer3d-plugin";

  rev = src.revision or (src.rev or (src.commit or (throw "cartographer3d-plugin pin has no revision")));
  shortRev = builtins.substring 0 12 rev;

  refName = src.version or (src.tag or (src.release or (src.branch or "main")));

  gitRefName = 
    if src ? version then src.version
    else if src ? tag then src.tag
    else if src ? release then src.release
    else if src ? branch then src.branch
    else "";

  version =
    if src ? version then lib.removePrefix "v" src.version
    else if src ? tag then lib.removePrefix "v" src.tag
    else if src ? release then lib.removePrefix "v" src.release
    else "1.8.0+git.${shortRev}";

  gitVersion = "${refName}-0-g${shortRev}";

  cartoPluginShim = py: py.buildPythonPackage rec {

  inherit src pname version;

  pyproject = true;

  nativeBuildInputs = [
    py.hatchling
    py.typing-extensions
  ];

  propagatedBuildInputs = [
    py.typing-extensions
    py.numpy
  ];

  postPatch = ''
    python - <<'PY'
from pathlib import Path
import re

version = "${version}"

pyproject = Path("pyproject.toml")
s = pyproject.read_text()

s = s.replace('dynamic = ["version"]', f'version = "{version}"')
s = s.replace('"hatch-vcs", ', "")
s = s.replace(', "hatch-vcs"', "")

s = re.sub(
    r'\n\[tool\.hatch\.version\]\n.*?(?=\n\[)',
    '\n',
    s,
    flags=re.S,
)
s = re.sub(
    r'\n\[tool\.hatch\.build\.hooks\.vcs\]\n.*?(?=\n\[)',
    '\n',
    s,
    flags=re.S,
)

pyproject.write_text(s)

Path("src/cartographer/__version__.py").write_text(
    f'version = "{version}"\n'
)

hook = Path("hatch_build.py")
h = hook.read_text()

h = re.sub(
    r'def get_commit_sha\(root: str\) -> str:\n'
    r'.*?'
    r'\ndef retrieve_git_version\(root: str\) -> str:\n'
    r'.*?'
    r'\ndef _is_ci\(\) -> bool:',
    'def get_commit_sha(root: str) -> str:\n'
    '    return os.getenv("COMMIT_SHA", "")\n\n'
    'def retrieve_git_version(root: str) -> str:\n'
    '    return os.getenv("GIT_VERSION", "")\n\n'
    'def _is_ci() -> bool:',
    h,
    flags=re.S,
)

hook.write_text(h)
PY
  '';

  GIT_VERSION = gitVersion;
  COMMIT_SHA = rev;
  GIT_REF_NAME = gitRefName;
  GIT_REPOSITORY = "Cartographer3D/cartographer3d-plugin";
  GIT_ACTIONS = "false";

  pythonImportsCheck = [
    "cartographer"
  ];

  doCheck = false;

  meta = {
    description = "Cartographer 3D probe plugin";
    homepage = "https://github.com/Cartographer3D/cartographer3d-plugin";
    license = lib.licenses.gpl3Only;
  };


  };
in stdenv.mkDerivation {
  inherit src pname;
  version = gitVersion;

  format = "other";

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/klippy/plugins
    cat > "$out/lib/klippy/plugins/cartographer.py" << 'PY'
from cartographer.extra import *
PY
    runHook postInstall
  '';

  passthru.extraPythonPackages = py: [
    (cartoPluginShim py)
  ];

}
