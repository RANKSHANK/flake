{...}: {
  imports = [
    ./bluetooth.nix
    ./browser
    ./netmanager.nix
    ./radicale.nix
    ./ssh
    ./tailscale.nix
    ./vpn-confinement.nix
    ./web-services
  ];
}
