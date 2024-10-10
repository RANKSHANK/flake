{
  description =
    "If it looks like I don't know what I'm doing, it's probably because I don't, if it does, you're probably mistaken.";
  inputs = {

    nix-stable.url = "github:nixos/nixpkgs/nixos-24.05";

    nix-staging.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    disko.url = "github:nix-community/disko";

    flatpak.url = "github:GermanBread/declarative-flatpak/dev";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";

    hyprland-plugins = {
        url =
            # "github:hyprwm/hyprland-plugins";
            "git+https://github.com/hyprwm/hyprland-plugins?submodules=1";
        inputs.hyprland.follows = "hyprland";
    };

    impermanence.url = "github:nix-community/Impermanence";

    lix = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";

    nix-gaming.url = "github:fufexan/nix-gaming";

    nur.url = "github:nix-community/NUR";

    stylix.url =
    "github:danth/stylix/ed91a20c84a80a525780dcb5ea3387dddf6cd2de";
    # "github:danth/stylix";
    # "/home/rankshank/projects/stylix/";
    # "/home/rankshank/projects/styprev/";
  };

  outputs = inputs@{ self, ... }:
    let
    inherit (inputs) nixpkgs;

      lib = nixpkgs.lib.extend (_: final: import ./lib { lib = final; });

      nixosModules = with inputs; [
        lix.nixosModules.default
        nix-gaming.nixosModules.pipewireLowLatency
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
        flatpak.nixosModules.default
        impermanence.nixosModules.impermanence
        nur.nixosModules.nur
        stylix.nixosModules.stylix
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
            ];
          });

      nixPMConfigurations = lib.genAttrs (lib.findTopLevelDirectories ./nixpm)
        (host:
          let
            path = ./nixpm/${host};
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
        }) [ "x86_64-linux" "armv7-linux" ]);
    };
}
