{lib, ...}: {
  networking.wireless.enable = lib.mkForce false;
}
