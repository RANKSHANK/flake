{lib, ...}: {
  imports = lib.flatten [
    [
      ./avahi.nix
      ./caddy.nix
      ./chagedetection-io.nix
      ./glance
      ./gotify.nix
      ./mealie.nix
      ./searxng.nix
      ./tor.nix
      ./vikunja.nix
    ]
    (lib.ternary lib.isDecrypted (import ./security.crypt.nix) {})
  ];
}
