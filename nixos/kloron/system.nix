{
  lib,
  modulesPath,
  ...
}: let
  inherit (lib.modules) mkForce;
in {

  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    kernelParams = [
      "vc4"
      "bcm2835_dma"
      "i2c_bcm2835"
      "snd_bcm2835.enable_hdmi=1"
    ];

    initrd = {
      availableKernelModules = {
        dw-hdmi = mkForce false;
        dw-mipi-dsi = mkForce false;
        phy-rockchip-pcie = mkForce false;
        pcie-rockchip-host = mkForce false;
        pwm-sun4i = mkForce false;
        rockchipdrm = mkForce false;
        rockchip-rga = mkForce false;
        sun4i-drm = mkForce false;
        sun8i-mixer = mkForce false;
        xhci_pci = true;
        usbhid = true;
      };
    };
  };

  system.stateVersion = "25.11";

  fileSystems."/" =
    { device = "/dev/disk/by-label/NIXOS_SD"; # this is important!
      fsType = "ext4";
      options = [ "noatime" ];
    };
}
