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
      kernelPackages = pkgs.linuxPackages_xanmod_latest;
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
      printing.enable = false;
      libinput.enable = true; # enables touchpad
      xserver = {
        xkb = {
            options = "caps:escape";
            layout = "us";
        };
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
      graphics = {
        enable = true;
        # enable32Bit = true;
        extraPackages = builtins.attrValues {
          inherit (pkgs) vaapiVdpau libvdpau-va-gl;
        };
      };
    };
  };
}
