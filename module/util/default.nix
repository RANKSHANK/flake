{
  lib,
  config,
  ...
}: {
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
    (lib.ternary (lib.isEnabled "xremap" ["desktop"]) ./xremap.nix [])
  ];
}
