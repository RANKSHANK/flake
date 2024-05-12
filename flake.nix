{
  description =
    "If it looks like I don't know what I'm doing, it's probably because I don't, if it does, you're probably mistaken.";
  inputs = {

    disko.url = "github:nix-community/disko";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nix-unstable";
    };

    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";

    hyprland-plugins = {
        url =
            # "github:hyprwm/hyprland-plugins";
            "git+https://github.com/hyprwm/hyprland-plugins?submodules=1";
        inputs.hyprland.follows = "hyprland";
    };

    impermanence.url = "github:nix-community/Impermanence";

    # neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";

    # nix-gaming.url = "github:fufexan/nix-gaming";

    nix-stable.url = "github:nixos/nixpkgs/nixos-24.05";

    nix-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    nixvim = {
        url = "github:nix-community/nixvim";
        # inputs.nixpkgs.follows = "nix-unstable";
    };

    nur.url = "github:nix-community/NUR";

    sops-nix= {
        url = "github:Mic92/sops-nix";
        inputs.nixpkgs.follows = "nix-unstable";
    };

    stylix.url =
    "github:danth/stylix";
    # "/home/rankshank/projects/stylix/";
    # "/home/rankshank/projects/styprev/";
  };

  outputs = inputs@{ self, ... }:
    let
      nixpkgs = inputs.nix-unstable;

      lib = nixpkgs.lib.extend (_: final: import ./lib { lib = final; });

      nixosModules = with inputs; [
        disko.nixosModules.disko
        home-manager.nixosModules.home-manager
        ({ user, ... }: {
          home-manager = {
            useUserPackages = true;
            useGlobalPkgs = true;
            users.${user}.home.stateVersion = "23.11";
            backupFileExtension = "bak";
          };
        })
        impermanence.nixosModules.impermanence
        nur.nixosModules.nur
        sops-nix.nixosModules.sops
        stylix.nixosModules.stylix
        nixvim.nixosModules.nixvim
      ];
    in {
      nixosConfigurations = lib.genAttrs (lib.findTopLevelDirectories ./nixos)
        (host:
          let
            path = ./nixos/${host};
            user = lib.readFileOrDefault "${path}/user" "rankshank";
            system =
              lib.readFileOrDefault "${path}/architecture" "x86_64-linux";
          in lib.nixosSystem {
            system.packages = [
                inputs.anyrun.packages.${system}.anyrun
            ];
            specialArgs = {
              inherit inputs lib;
              user = user;
              modulesPath = "${nixpkgs}/nixos/modules";
            };
            modules = lib.flatten [
              nixosModules
              (import (lib.ternary (host == "iso")
                "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
                "${nixpkgs}/nixos/modules/module-list.nix"))
              (lib.listNixFilesRecursively path)
              (lib.filterModules (lib.listNixFilesRecursively ./module))
              ({ lib, ... }: {
                networking.hostName = host;
                nixpkgs.hostPlatform = system;
                system.stateVersion = "23.11";
                programs.nano.enable = false;
              })
              # ({ pkgs, ... }: {
              #   stylix.swatches = builtins.trace "loaded" {
              #       hyprland.base16Scheme = "${pkgs.base16-schemes}/share/themes/kanagawa.yaml";
              #       fish.base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
              #       vim.base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
              #       rofi.base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-latte.yaml";
              #       terminal.base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine.yaml";
              #   };
              # })
              # ({ config, user, pkgs, ... }: {
              #   stylix = {
              #     # swatches.terminal = {
              #     #   base16Scheme = "${pkgs.base16-schemes}/share/themes/dracula.yaml";
              #     #   override = {
              #     #     base00 = "000000";
              #     #     swatches.tab.active.hovered = ({ colors, mkSwatch, ... }: with colors; mkSwatch base09 base05 base01);
              #     #   };
              #     # };
              #     schemeOverrides = {
              #       kitty = {
              #         scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-latte.yaml";
              #         override = {
              #           base08 = "dadbad";
              #           # red = { mkColor, ... }: mkColor "dadbad";
              #         };
              #       };
              #     };
              #   };
              #   # environment.etc."test".text = builtins.trace (config.lib.stylix.getSwatches [ "terminal" ]).swatches.tab.active (config.lib.stylix.getSwatches [ "terminal" ]).swatches.tab.active.hovered.foreground.asHex;
              #   # environment.etc."test1".text = (config.lib.stylix.getPalette [ "terminal" ]).colors.base00;
              #   environment.etc."test2".text = (config.stylix.palettes.kitty.scheme.base08);
              # })
            ];
          });

      devShells = let shells = lib.listNixFilesRecursively ./shell;
      in lib.listToAttrs (map (system:
        let pkgs = import nixpkgs { inherit system; };
        in {
          name = system;
          value = lib.listToAttrs (map (shell: {
            name = lib.pipe shell [
              toString
              (lib.removeSuffix ".nix")
              (lib.splitString "/")
              (lib.last)
            ];
            value = import shell { inherit pkgs lib; };
          }) shells);
        }) [ "x86_64-linux" ]);
    };
}
