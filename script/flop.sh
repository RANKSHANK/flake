#!/usr/bin/env bash
echo "adding untracked files..."
git add .
[[ "$UID" -eq 0 ]] || exec sudo bash "$0" "$@"
echo "rebuilding system"
prev=$(readlink -f /run/current-system)
nixos-rebuild --option eval-cache false --upgrade-all switch --flake . "$@" |& nom
nvd diff "$prev" /run/current-system
