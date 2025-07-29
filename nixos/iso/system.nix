{
  lib,
  modulesPath,
  pkgs,
  ...
}: {
  system.stateVersion = "25.05";

  networking.wireless.enable = lib.mkForce false;

  boot = {
    supportedFilesystems = lib.mkForce [
      "btrfs"
      "reisrefs"
      "vfat"
      "f2fs"
      "xfs"
      "ntfs"
      "cifs"
    ];
  };
}
