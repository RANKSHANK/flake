{pkgs ? import <nixpkgs> {}, ...}: let
  flup = pkgs.writeShellScriptBin "flup" ''
    #!/usr/bin/env bash
    [[ "$UID" -eq 0 ]] || exec sudo bash "$0" "$@"
    echo "adding untracked files..."
    git add .
    echo "updating flake..."
    sudo nix flake update
    echo "rebuilding system"
    prev=$(readlink -f /run/current-system)
    sudo nixos-rebuild --upgrade-all switch --flake . $@  |& nom
    if command -v flatpak &> /dev/null; then
      sudo flatpak update -y
    fi
    nvd diff $prev /run/current-system
  '';
  flop = pkgs.writeShellScriptBin "flop" ''
    #!/usr/bin/env bash
    [[ "$UID" -eq 0 ]] || exec sudo bash "$0" "$@"
    echo "adding untracked files..."
    git add .
    echo "rebuilding system"
    prev=$(readlink -f /run/current-system)
    sudo nixos-rebuild --option eval-cache false --upgrade-all switch --flake . $@ |& nom
    nvd diff $prev /run/current-system
  '';
in
  pkgs.mkShell {
    packages = builtins.attrValues {
      inherit (pkgs) age nil sops nvd nix-output-monitor lua-language-server;
      inherit flup flop;
    };
  }
