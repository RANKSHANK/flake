{
  description =
    "If it looks like I don't know what I'm doing, it's probably because I don't, if it does, you're probably mistaken.";
  inputs = {

    anyrun = {
        url = "github:Kirottu/anyrun";
        inputs.nixpkgs.follows = "nix-unstable";
    };

    disko.url = "github:nix-community/disko";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nix-unstable";
    };

    hyprland.url = "github:hyprwm/Hyprland";

    hyprland-plugins = {
        url = "github:hyprwm/hyprland-plugins";
        inputs.hyprland.follows = "hyprland";
    };

    impermanence.url = "github:nix-community/Impermanence";

    # nixvim has this anyways
    # neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";

    nix-gaming.url = "github:fufexan/nix-gaming";

    nix-stable.url = "github:nixos/nixpkgs/nixos-23.11";

    nix-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    nixvim = {
        url = "github:nix-community/nixvim";
        inputs.nixpkgs.follows = "nix-unstable";
    };

    nur.url = "github:nix-community/NUR";

    sops-nix= {
        url = "github:Mic92/sops-nix";
        inputs.nixpkgs.follows = "nix-unstable";
    };

    stylix.url = #"github:danth/stylix"; 
    "/home/rankshank/projects/stylix/";
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
        }) [ "x86_64-linux" ]);
    };
}
