{
  decrypted,
  lib,
  util,
  ...
}: let
  inherit (lib.lists) flatten;
  inherit (util) ternary;
in {
  imports = flatten [
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
    (ternary decrypted ./security.crypt.nix [])
  ];
}
