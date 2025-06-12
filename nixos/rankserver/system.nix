{
  config,
  inputs,
  pkgs,
  user,
  ...
}: {
    documentation.enable = false; # Breaks Nixos-Install due to cross sys linking? TODO: read into this
    powerManagement.cpuFreqGovernor = "performance";

    environment.sessionVariables = {
        LIBVA_DRIVER_NAME = "iHD";
    };

    hardware = {
        cpu.intel.updateMicrocode = config.hardware.enableRedistributableFirmware;
        graphics = {
            enable = true;
            extraPackages = builtins.attrValues {
                inherit (pkgs)  
                    intel-media-driver
                    intel-compute-runtime
                    vpl-gpu-rt
                    intel-ocl;
            };
        };
    };

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

    users.users.${user} = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "video"
        "adbusers"
        "tty"
        "dialout"
      ];
    };

    services = {
      printing.enable = false; #CUPS Vuln
      libinput.enable = true; # enables touchpad
      xserver = {
        #enable = true; # Doesn't need to be enabled to allow xkb in tty
        xkb = {
          options = "caps:escape";
          layout = "us";
        };
      };
  };
}
