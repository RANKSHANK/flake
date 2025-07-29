{
  lib,
  config,
  user,
  ...
}: let
  inherit (builtins) elem filter foldl' head readFile unsafeDiscardStringContext;
  keys =
    foldl' (acc: attr: acc // attr) {
      client = [];
      builder = [];
    } (lib.flatten (map (keyPath:
      lib.pipe keyPath [
        (lib.splitString "/")
        (lib.last)
        (lib.splitString ".")
        (
          strs: let
            name = head strs;
            key = readFile keyPath;
            attr = (map (tag: {
                hostName = name;
                sshUser = user;
                ${unsafeDiscardStringContext tag} = [key];
              }) strs);
            in
              lib.mkIf (name != config.networking.hostName) {
                client = lib.mkIf (elem "client" strs) attr;
                builder = lib.mkIf (elem "builder strs") attr;
              }
        )])
    (lib.listTargetFilesRecursively ".pub" ./keys)));
in
  lib.mkModule "ssh" ["connectivity"] {
    programs = {
      mtr.enable = true;
      ssh = {
        # startAgent = true;
        agentTimeout = "5m";
        extraConfig = "AddKeysToAgent yes";
      };
    };
    # security.pam.sshAgentAuth.enable = true;
    services.openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };

    users.users.${user}.openssh.authorizedKeys.keys = lib.mkIf lib.isDecrypted keys.client;

    nix = lib.mkIf (lib.isDecrypted) {
      distributedBuilds = true;
      buildMachines = keys.builder;
    };
  }
