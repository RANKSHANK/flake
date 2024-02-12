{
  pkgs,
  user,
  ...
}: {
  config = {
    documentation.enable = false;

    powerManagement.cpuFreqGovernor = "performance";

    boot = {
      binfmt.emulatedSystems = [
        "armv7l-linux"
      ];
      supportedFilesystems = [
        "btrfs"
      ];
      loader = {
        grub = {
          enable = true;
          devices = [
            "nodev"
          ];
          efiSupport = true;
          #efiInstallAsRemovable = true;
          enableCryptodisk = true;
          configurationLimit = 25;
        };
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
      useXkbConfig = true; # use xkbOptions in tty.
    };

    users = {
      mutableUsers = false;
      users = {
        root = {
          hashedPassword = "!";
        };
        ${user} = {
          isNormalUser = true;
          extraGroups = [
            "wheel"
            "video"
          ];
          hashedPasswordFile = "/persist/etc/shadow.d/${user}";
        };
      };
    };

    services = {
      printing.enable = true;
      xserver = {
        layout = "us";
        libinput.enable = true; # enables touchpad
        xkbOptions = "caps:escape";
      };
    };

    hardware = {
      enableAllFirmware = true;
      nvidia = {
        prime = {
          intelBusId = "PCI:0:2:0";
          nvidiaBusId = "PCI:1:0:0";
        };
      };
      opengl = {
        enable = true;
        driSupport32Bit = true;
        extraPackages = builtins.attrValues {
          inherit (pkgs) vaapiVdpau libvdpau-va-gl;
        };
      };
    };
  };
}
