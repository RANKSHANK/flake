{
  decrypted,
  util,
  ...
}: let
  inherit (util) ternary;
in {
  imports = [
    ./icons.nix
    ./options.nix
  ] ++ (ternary decrypted [
    ./bookmarks.crypt.nix
  ] []);
}
