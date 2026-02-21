{
  decrypted,
  config,
  lib,
  user,
  util,
  ...
}: let
  inherit (builtins) elem foldl' head readFile unsafeDiscardStringContext;
  inherit (lib.modules) mkIf;
  inherit (lib.lists) flatten last;
  inherit (lib.trivial) pipe;
  inherit (lib.strings) splitString;
  inherit (util) mkModule listTargetFilesRecursively ternary;
  keys =
    foldl' (acc: attr: acc // attr) {
      client = [];
      builder = [];
    } (flatten (map (keyPath:
      pipe keyPath [
        (splitString "/")
        last
        (splitString ".")
        (
          strs: let
            name = head strs;
            key = readFile keyPath;
            attr =
              map (tag: {
                hostName = name;
                sshUser = user;
                ${unsafeDiscardStringContext tag} = [key];
              })
              strs;
          in
            mkIf (name != config.networking.hostName) {
              client = mkIf (elem "client" strs) attr;
              builder = mkIf (elem "builder strs") attr;
            }
        )
      ])
    (listTargetFilesRecursively ".pub" ./keys)));
in
  mkModule "ssh" ["connectivity"] {
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

    users.users.${user}.openssh.authorizedKeys.keys = mkIf decrypted keys.client;

    nix = mkIf decrypted {
      distributedBuilds = true;
      buildMachines = keys.builder;
      settings.trusted-users = [ "nixremote" ];
    };
  }
