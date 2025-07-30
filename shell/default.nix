{
  lib,
  pkgs,
  ...
}: let
  inherit (lib.attrsets) attrValues;
  inherit (lib.trivial) readFile;
  flup = pkgs.writeShellScriptBin "flup" (readFile ../script/flup.sh);
  flop = pkgs.writeShellScriptBin "flop" (readFile ../script/flop.sh);
in
  pkgs.mkShell {
    packages = attrValues {
      inherit (pkgs) git-crypt gnupg nil npins nvd nix-output-monitor;
      inherit flup flop;
    };
  }
