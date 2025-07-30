{
  config,
  lib,
  util,
  ...
}: let
  inherit (lib.modules) mkForce;
  inherit (util) mkModule;
in
  mkModule "changedetection-io" ["server"] {
    nixpkgs.overlays = [
      (self: super: {
        changedetection-io = super.changedetection-io.overridePythonAttrs (old: {
          propagatedBuildInputs =
            super.changedetection-io.propagatedBuildInputs
            ++ [
              super.python3.pkgs.extruct
            ];
        });
      })
    ];

    services = {
      changedetection-io = {
        enable = true;
        # webDriverSupport = true;
        playwrightSupport = true;
        behindProxy = true;
        baseURL = "https://changedetection-io.${config.baseURL}";
      };
    };

    webservices."changedetection-io" = "${config.services.changedetection-io.listenAddress}:${toString config.services.changedetection-io.port}";

    systemd.services.changedetection-io = {
      after = mkForce ["network-online.target"];
      wants = mkForce ["network-online.target"];
    };
  }
