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
