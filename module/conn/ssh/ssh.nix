{
  lib,
  config,
  user,
  ...
}: let
  keys =
    builtins.foldl' (acc: attr: acc // attr) {
      client = [];
      builder = [];
    } (lib.flatten (map (keyPath:
      lib.pipe keyPath [
        (lib.splitString "/")
        (lib.last)
        (lib.splitString ".")
        (
          strs: let
            name = builtins.head strs;
            key = builtins.readFile keyPath;
            filtered = builtins.filter (str: builtins.elem str ["client" "builder"]) strs;
          in
            lib.ternary (name == config.networking.hostName) {} (map (tag: {
                ${builtins.unsafeDiscardStringContext tag} = [key];
              })
              filtered)
        )
      ])
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

    # nix = lib.mkIf (config.decrypted) {
    #   distributedBuilds = true;
    #   buildMachines = keys.builder;
    # };
  }
