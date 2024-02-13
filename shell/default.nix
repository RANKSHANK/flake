{pkgs ? import <nixpkgs> {}, ...}: let
  flup = pkgs.writeShellScriptBin "flup" (builtins.readFile ../script/flup.sh);
  flop = pkgs.writeShellScriptBin "flop" (builtins.readFile ../script/flop.sh);
in
  pkgs.mkShell {
    packages = builtins.attrValues {
      inherit (pkgs) age nil sops nvd nix-output-monitor lua-language-server;
      inherit (pkgs.nodePackages) bash-language-server;
      inherit flup flop;
    };
  }
