{
  config,
  pkgs,
  user,
  ...
}: {
    #documentation.enable = false; # Breaks Nixos-Install due to cross sys linking? TODO: read into this
    powerManagement.cpuFreqGovernor = "performance";
    hardware.cpu.intel.updateMicrocode = config.hardware.enableRedistributableFirmware;

    boot = {
      supportedFilesystems = [
        "btrfs"
      ];
      loader = {
        grub = {
          enable = true;
          devices = [
            "/dev/sda"
          ];
          efiSupport = true;
          efiInstallAsRemovable = true;
          enableCryptodisk = true;
          configurationLimit = 25;
          extraConfig = ''
            numlock=on
          '';
        };
        systemd-boot.enable = false;
      };
      initrd = {
        availableKernelModules = [
          "xhci_pci"
          "ahci"
          "nvme"
          "usbhid"
          "usb_storage"
          "ums_realtek"
          "sd_mod"
        ];
        luks = {
          reusePassphrases = true;
        };
      };
      kernelPackages = pkgs.linuxPackages_zen;
      kernelModules = [
        "kvm-intel"
      ];
    };

    time.timeZone = "Australia/Sydney";

    i18n.defaultLocale = "en_US.UTF-8";
    console = {
      # font = "Lat2-Terminus16";
      #keyMap = "us";
      useXkbConfig = true; # use xkbOptions in tty.
    };

    users.users.${user} = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "video"
      ];
      hashedPasswordFile = "/persist/hash/rankshank";
    };

    services = {
      printing.enable = true;
      xserver = {
        #enable = true; # Doesn't need to be enabled to allow xkb in tty
        libinput.enable = true; # enables touchpad
        xkb = {
          options = "caps:escape";
          layout = "us";
        };
      };
  };
}
