{ ... }:

{
    imports = [
        ./bluetooth.nix
        ./browser
        ./netmanager.nix
        ./protonvpn.nix
        ./radicale.nix
        ./ssh
        ./tailscale.nix
        ./vpn-confinement.nix
        ./web-services
    ];
}
