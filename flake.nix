{
  description = "If it looks like I don't know what I'm doing, it's probably because I don't, if it does, you're probably mistaken.";

  inputs = {

    nix-stable.url = "github:nixos/nixpkgs/nixos-25.05";

    nix-staging.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    disko.url = "github:nix-community/disko";

    flatpak.url = "github:GermanBread/declarative-flatpak/dev";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
        url = "github:hyprwm/Hyprland";
    };

    hyprland-plugins = {
        url = "github:hyprwm/hyprland-plugins";
        inputs.hyprland.follows = "hyprland";
    };

    impermanence.url = "github:nix-community/Impermanence";

    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";

    nix-gaming.url = "github:fufexan/nix-gaming";

    nur.url = "github:nix-community/NUR";

    nvf = {
        url = 
            #"github:notashelf/nvf";
            "/home/rankshank/projects/nvf";
        inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify = {
        url = "github:Gerg-L/spicetify-nix";
        inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
        url =
        "github:danth/stylix";
        # "/home/rankshank/projects/stylix/";
        inputs.nixpkgs.follows = "nixpkgs";
    };

    vpn-confinement.url = "github:Maroka-chan/VPN-Confinement";
    
    xremap = {
        url = "github:xremap/nix-flake";
        inputs = {
            xremap = {
                url = 
                # "/home/rankshank/projects/xremap";
                "github:RANKSHANK/xremap?ref=hyprland-bindings-update";
                #"github:xremap/xremap";
                # "/tmp/xremap";
            };
            hyprland.follows = "hyprland";
        };
    };

  };

  outputs = inputs@{ self, ... }: let

      inherit (inputs) nixpkgs;
      
      lib = nixpkgs.lib.extend (_: final: import ./lib { lib = final; });
      
      eachSys = lib.genAttrs lib.platforms.all;

    in {
 
      packages = let 
        names = lib.findTopLevelDirectories ./package;
      in eachSys (system: let
        pkgs = nixpkgs.legacyPackages.${system};
        packaged = (builtins.foldl' (acc: name: 
          acc // { ${name} = (import ./package/${name}/${name}.nix {
                inherit pkgs inputs lib;
              }); 
            }
          ) {} names);
      in packaged // { default = packaged.nvf; });

      nixosConfigurations = lib.genAttrs (lib.findTopLevelDirectories ./nixos)
        (host:
          let
            path = ./nixos/${host};
            user = lib.readFileOrDefault "${path}/user" "rankshank";
            system = lib.readFileOrDefault "${path}/architecture" "x86_64-linux";
            lib = nixpkgs.lib.extend (_: final: import ./lib { lib = final; enables = import ./nixos/${host}/modules.nix; });
          in lib.nixosSystem {
            specialArgs = {
              inherit inputs lib;
              pkgs-stable = inputs.nix-stable.legacyPackages.${system};
              pkgs-staging = inputs.nix-staging.legacyPackages.${system};
              user = user;
              modulesPath = "${nixpkgs}/nixos/modules";
            };
            modules = lib.flatten [
              (with inputs; [
                home-manager.nixosModules.home-manager
                stylix.nixosModules.stylix
                nix-gaming.nixosModules.pipewireLowLatency
                disko.nixosModules.disko
                spicetify.nixosModules.default
              ])
              ({ user, ... }: {
                home-manager = {
                  useUserPackages = true;
                  useGlobalPkgs = true;
                  users.${user}.home.stateVersion = "23.11";
                  backupFileExtension = "bak";
                };
              })
              (import (lib.ternary (host == "iso")
                "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
                "${nixpkgs}/nixos/modules/module-list.nix"))
              (lib.listNixFilesRecursively path)
              ./module
              ({ ... }: {
                networking.hostName = host;
                nixpkgs.hostPlatform = system;
                system.stateVersion = "23.11";
                programs.nano.enable = false;
              })
            ];
          });

      devShells = let
        shells = lib.listNixFilesRecursively ./shell;
      in lib.listToAttrs (map (system:
        let 
            pkgs = import nixpkgs { inherit system; };
        in {
          name = system;
          value = lib.listToAttrs (map (shell: {
            name = lib.pipe shell [
              toString
              (lib.removeSuffix ".nix")
              (lib.splitString "/")
              (lib.last)
            ];
            value = import shell { inherit inputs pkgs lib; };
          }) shells);
        }) lib.platforms.all);

    };
}
