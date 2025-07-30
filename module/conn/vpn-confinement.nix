{
  inputs,
  util,
  ...
}: let
  inherit (util) mkModule;
in
  mkModule "vpn-confinement" ["server"] {
    imports = [
      inputs.vpn-confinement.nixosModules.default
    ];
  }
