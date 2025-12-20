{
  inputs,
  ...
}: {

  imports = [
    inputs.nixos-wsl.nixosModules.default
  ];

  system.stateVersion = "25.05";

  wsl.enable = true;

}
