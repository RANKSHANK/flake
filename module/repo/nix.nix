{
  inputs,
  lib,
  util,
  ...
}: let
  inherit (lib.attrsets) attrNames attrValues filterAttrs mapAttrs;
  inherit (lib.types) isType;
  inherit (util) mkModule;
in
  mkModule "nix" ["repo"] {
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
      registry = mapAttrs (_: v: {flake = v;}) (filterAttrs (_: v: isType "flake" v) inputs);
      extraOptions = "gc-keep-outputs = true";

      settings = let
        cachix = {
          "https://nix-community.cachix.org" = "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=";
          "https://hyprland.cachix.org" = "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=";
          "https://ghostty.cachix.org" = "ghostty.cachix.org-1:QB389yTa6gTyneehvqG58y0WnHjQOqgnA+wBnpWWxns=";
          "https://neovim-nightly.cachix.org" = "neovim-nightly.cachix.org-1:feIoInHRevVEplgdZvQDjhp11kYASYCE2NGY9hNrwxY=";
          # "https://ros.cachix.org" = "ros.cachix.org-1:dSyZxI8geDCJrwgvCOHDoAfOm5sV1wCPjBkKL+38Rvo=";
        };
      in {
        builders-use-substitutes = true;
        auto-optimise-store = true;
        warn-dirty = false;
        experimental-features = [
          "nix-command"
          "flakes"
          "auto-allocate-uids"
        ];
        substituters = attrNames cachix;
        trusted-public-keys = attrValues cachix;
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
