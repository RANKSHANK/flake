{
  lib,
  config,
  user,
  util,
  ...
}: let
  inherit (lib.attrsets) attrNames attrValues;
  inherit (lib.lists) filter;
  inherit (util) mkModule;
  home = str: "/home/${user}/${str}";
  devices = {
    rankdesktop = {id = "CWHD2SX-3EMIPMJ-RMO5HAR-5YPRJ6E-E26PXGS-FATQ555-A5GSLVE-NL4DGAT";};
    ranklaptop = {id = "4KYMEMZ-KDF2KQM-CJNJODW-SP34WEL-YRRG2WI-MMSEX2D-SYFUNQW-3SKMUQJ";};
    rankcell = {id = "MQ2VK4N-AKT2PMJ-NE52CVW-E3NCRPF-IV2H5WG-B5Y5NP7-2763MNY-CXWJXQE";};
  };
  kindle = {id = "R5GXT4H-SUJANUT-7MX7Z4T-XCKRMD5-6RETM3O-WYXKEZE-5F73SGW-BNIVNAB";};
  withoutSelf = filter (device: device != config.networking.hostName) (attrNames devices);
  genFolder = name: opts:
    opts
    // {
      path = home name;
      devices = withoutSelf;
    };
  folders = {
    "documents" = genFolder "documents" {};
    "images" = genFolder "images" {};
    "misc" = genFolder "misc" {};
    "audio" = genFolder "audio" {};
    "video" = genFolder "video" {};
  };
in
  mkModule "syncthing" ["connectivity" "sync"] {
    services.syncthing = {
      enable = true;
      user = "rankshank";
      dataDir = home ".cache/syncthing";
      configDir = home ".config/syncthing";
      openDefaultPorts = true;
      overrideDevices = true;
      overrideFolders = true;
      settings = {
        inherit folders;
        devices = devices // {inherit kindle;};
        options = {
          urAccepted = -1;
        };
      };
    };

    systemd = {
      services.syncthing.serviceConfig.UMask = "0007";
      tmpfiles.rules = map (attr: "d ${attr.path} 2770 ${user} syncthing") (attrValues config.services.syncthing.settings.folders);
    };
  }
