#!/usr/bin/env bash
[[ "$UID" -eq 0 ]] || exec sudo bash "$0" "$@"
echo "adding untracked files..."
git add .
echo "rebuilding system"
prev=$(readlink -f /run/current-system)
sudo nixos-rebuild --option eval-cache false --upgrade-all switch --flake . "$@" |& nom
nvd diff "$prev" /run/current-system
