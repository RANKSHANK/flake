{
  inputs,
  pkgs,
  config,
  lib,
  ...
}: lib.mkModule "nix" [ "repo" ] {

    imports = [
        inputs.nur.modules.nixos.default
    ];

    programs.nix-ld = {
        enable = true;
    };

    nixpkgs = {
      config = {
        allowUnfree = true; #Drivers
      };
    };

    nix = {
      # package = inputs.nixpkgs.legacyPackages.${pkgs.system}.git;
      registry = lib.mapAttrs (_: v: {flake = v;}) (lib.filterAttrs (_: v: lib.isType "flake" v) inputs);

      settings = {
        builders-use-substitutes = true;
        auto-optimise-store = true;
        warn-dirty = false;
        experimental-features = [
          "nix-command"
          "flakes"
          "auto-allocate-uids"
        ];
        substituters = [
          "https://cache.nixos.org/"
          "https://nix-community.cachix.org"
          "https://hyprland.cachix.org"
          "https://ros.cachix.org"
        ];
        trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
          "ros.cachix.org-1:dSyZxI8geDCJrwgvCOHDoAfOm5sV1wCPjBkKL+38Rvo="
        ];
        trusted-users = ["root"];
        allowed-users = ["@wheel"];
      };
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
      };
    };
}
