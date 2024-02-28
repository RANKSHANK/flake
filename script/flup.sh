#!/usr/bin/env bash
[[ "$UID" -eq 0 ]] || exec sudo bash "$0" "$@"
echo "adding untracked changes to git..."
git add .
echo "updating flake..."
if [ ! -d "./.prev_locks" ]; then
    mkdir ".prev_locks"
fi
if [ ! -f "./.prev_locks/0.lock" ]; then
    cp -rp "./flake.lock" "./.prev_locks/0.lock"
fi
pass=$(sudo nix flake update)
if [[ $pass != 0 ]]; then
    exit 1
fi
backup="$(cmp --silent ./flake.lock ./.prev_locks/0.lock; echo $?)"
if [[ $backup -ne 0 ]]; then
    next="./.prev_locks/9.lock"
    for i in $(seq 8 -1 0); do
        prev="./.prev_locks/$i.lock"
        if [ -f "$prev" ]; then
            mv -f "$prev" "$next"
        fi
        next=$prev
    done
    cp -rp "./flake.lock" "./.prev_locks/0.lock"
fi
echo "rebuilding system"
prev=$(readlink -f /run/current-system)
sudo nixos-rebuild --upgrade-all switch --flake . "$@"  |& nom
if command -v flatpak &> /dev/null; then
    sudo flatpak update -y
fi
nvd diff "$prev" /run/current-system
