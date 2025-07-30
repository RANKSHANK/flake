{
  lib,
  util,
  ...
}: let
  inherit (util) ternary isEnabled;
in {
  imports = lib.flatten [
    ./bitwarden.nix
    ./btop.nix
    ./direnv.nix
    ./git.nix
    ./gpg.nix
    ./nvtop.nix
    ./ripgrep.nix
    ./sudo.nix
    ./unzip.nix
    ./user.nix
    (ternary (isEnabled "xremap" ["desktop"]) ./xremap.nix [])
  ];
}
