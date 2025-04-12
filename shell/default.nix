{ inputs, pkgs, ...}: let
  flup = pkgs.writeShellScriptBin "flup" (builtins.readFile ../script/flup.sh);
  flop = pkgs.writeShellScriptBin "flop" (builtins.readFile ../script/flop.sh);
in
  pkgs.mkShell {
    packages = builtins.attrValues {
      inherit (pkgs) git-crypt gnupg nil nvd nix-output-monitor;
      inherit flup flop;
    };
  }
