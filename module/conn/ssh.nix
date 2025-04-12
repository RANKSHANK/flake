{ lib, config, ... }:

lib.mkModule "ssh" [ "connectivity" ] {
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
    nix = lib.mkIf config.modules.nix.enabled {
      distributedBuilds = true;
      buildMachines = [
      ];
    };
}
