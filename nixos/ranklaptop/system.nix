{
  pkgs,
  user,
  ...
}: {
  system.stateVersion = "23.11";

  documentation.enable = false;

  powerManagement.cpuFreqGovernor = "performance";

  nix.settings.extra-platforms = [ "aarch64-linux" "arm-linux" ];

  boot = {
    binfmt.emulatedSystems = [
      "armv7l-linux"
      "aarch64-linux"
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
        hashedPasswordFile = "/persist/etc/shadow.d/${user}";
      };
    };
  };

  services = {
    btrfs.autoScrub = {
      enable = true;
      interval = "weekly";
      fileSystems = ["/"];
    };
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
  };
}
