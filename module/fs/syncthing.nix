{
  lib,
  config,
  user,
  ...
}: let
  home = str: "/home/${user}/${str}";
  devices = {
    rankdesktop = { id = "CWHD2SX-3EMIPMJ-RMO5HAR-5YPRJ6E-E26PXGS-FATQ555-A5GSLVE-NL4DGAT"; };
    ranklaptop = { id = "4KYMEMZ-KDF2KQM-CJNJODW-SP34WEL-YRRG2WI-MMSEX2D-SYFUNQW-3SKMUQJ"; };
    rankcell = { id = "YBUWEPL-XCHUED2-53HRUTU-GHFN34W-XYZX2AJ-CSWBQSW-QCTJS5W-FLKB2QV"; };
  };
  withoutSelf = builtins.filter (device: device != config.networking.hostName) (builtins.attrNames devices);
  genFolder = name: opts:
    opts
    // {
      path = home name;
      devices = withoutSelf;
    };
  folders = {
    "document" = genFolder "document" {};
    "image" = genFolder "image" {};
    "misc" = genFolder "misc" {};
    "audio" = genFolder "audio" {};
    "video" = genFolder "video" {};
  };
in lib.mkModule "syncthing" [ "connectivity" "sync" ] config {
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
        inherit devices;
        options = {
          urAccepted = -1;
        };
      };
    };

    systemd = {
      services.syncthing.serviceConfig.UMask = "0007";
      tmpfiles.rules = builtins.map (attr: "d ${attr.path} 2770 ${user} syncthing") (builtins.attrValues config.services.syncthing.settings.folders);
    };
}
