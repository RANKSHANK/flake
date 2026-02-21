{
  description = "My personal collection of technical debt.";

  inputs = {

    nix-stable.url = "github:nixos/nixpkgs/nixos-25.11";

    nix-staging.url = "github:nixos/nixpkgs/master";

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    nix-wsl.url = "github:nix-community/NixOS-WSL/main";

    disko.url = "github:nix-community/disko";

    flatpak.url = "github:GermanBread/declarative-flatpak/dev";

    ghostty = {
      url = "github:ghostty-org/ghostty";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    hypr-easymotion = {
      url = "github:zakk4223/hyprland-easymotion";
      inputs.hyprland.follows = "hyprland";
    };

    impermanence.url = "github:nix-community/Impermanence";

    mnw.url = "github:Gerg-L/mnw";

    mqsw.url = "github:RANKSHANK/mqsw";
    #"/home/rankshank/projects/mqsw";

    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";

    nix-gaming.url = "github:fufexan/nix-gaming";

    nur.url = "github:nix-community/NUR";

    quickshell = {
      url = "github:quickshell-mirror/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix";
      # "/home/rankshank/projects/stylix/";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    vpn-confinement.url = "github:Maroka-chan/VPN-Confinement";

    xremap = {
      url = "github:xremap/nix-flake";
      inputs = {
        xremap = {
          # url = "github:RANKSHANK/xremap?ref=hyprland-bindings-update";
          url = "github:xremap/xremap";
        };
      };
    };
  };

  outputs = inputs @ {self, ...}: let
    inherit (inputs) nixpkgs;
    inherit (nixpkgs) lib;

    inherit (builtins) pathExists readDir;

    inherit (lib.attrsets) attrValues genAttrs filterAttrs listToAttrs mapAttrs' nameValuePair;
    inherit (lib.lists) flatten last;
    inherit (lib.platforms) all;
    inherit (lib.strings) hasSuffix removeSuffix splitString;
    inherit (lib.trivial) pipe;

    util = import ./util {inherit (nixpkgs) lib;};

    inherit (util) fromNpins findTopLevelDirectories listNixFilesRecursively readFileOrDefault ternary;

    eachSys = genAttrs all;
  in {
    formatter = eachSys (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in
      pkgs.writeShellApplication {
        name = "flake-format";
        runtimeInputs = attrValues {
          inherit (pkgs) alejandra fd stylua;
        };
        text = ''
          fd "$@" -t f -e nix -x alejandra -q '{}'
          fd "$@" -t f -e lua -x stylua -f '${./stylua.toml}' '{}'
        '';
      });

    packages = let
      targets = filterAttrs (name: attr: !(hasSuffix ".json" name)) (readDir ./package);
    in
      eachSys (system: let
        pkgs = nixpkgs.legacyPackages.${system};
        extraSpecialArgs = {
          inherit self pkgs inputs;
          util = util // (import ./util/packages-util.nix {inherit pkgs lib util;});
          fromNpins = fromNpins ./package/packages.json;
        };
        pack = name: val:
          nameValuePair name (pkgs.callPackage val extraSpecialArgs);
        packaged =
          mapAttrs' (
            name: type: (
              ternary (type == "directory")
              (pack name ./package/${name}/${name}.nix)
              (pack (removeSuffix ".nix" name) ./package/${name})
            )
          )
          targets;
      in
        packaged // {default = packaged.nvim.devMode;});

    nixosConfigurations =
      genAttrs (findTopLevelDirectories ./nixos)
      (host: let
        path = ./nixos/${host};
        user = readFileOrDefault "${path}/user" "rankshank";
        system = readFileOrDefault "${path}/architecture" "x86_64-linux";
        pkgs = nixpkgs.legacyPackages.${system};
        util = nixpkgs.lib.extend (_: _: (
          import ./util {
            inherit lib;
            enables = let
              attrs = import ./nixos/${host}/modules.nix;
            in
              attrs
              // {
                disabledModules = flatten [
                  attrs.disabledModules
                  (pkgs.callPackage ./util/broken-modules.nix {inherit util inputs;})
                ];
              };
          }) // import ./util/packages-util.nix { inherit lib pkgs; });
      in
        lib.nixosSystem {
          specialArgs = {
            inherit inputs self util user;
            decrypted = pathExists "${path}/decrypted";
            pkgs-stable = inputs.nix-stable.legacyPackages.${system};
            pkgs-staging = inputs.nix-staging.legacyPackages.${system};
            modulesPath = "${nixpkgs}/nixos/modules";
          };
          modules = flatten [
            (with inputs; [
              home-manager.nixosModules.home-manager
              stylix.nixosModules.stylix
              nix-gaming.nixosModules.pipewireLowLatency
              disko.nixosModules.disko
              spicetify.nixosModules.default
            ])
            ({user, ...}: {
              home-manager = {
                useUserPackages = true;
                useGlobalPkgs = true;
                users.${user}.home.stateVersion = "23.11";
                backupFileExtension = "bak";
              };
            })
            (import (ternary (host == "iso")
              "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
              "${nixpkgs}/nixos/modules/module-list.nix"))
            (listNixFilesRecursively path)
            ./module
            ({...}: {
              networking.hostName = host;
              nixpkgs.hostPlatform = system;
              programs.nano.enable = false;
            })
          ];
        });

    devShells = let
      shells = listNixFilesRecursively ./shell;
    in
      listToAttrs (map (system: let
          pkgs = import nixpkgs {inherit system util;};
        in {
          name = system;
          value = listToAttrs (map (shell: {
              name = pipe shell [
                toString
                (removeSuffix ".nix")
                (splitString "/")
                last
              ];
              value = pkgs.callPackage shell {inherit inputs util;};
            })
            shells);
        })
        all);
  };
}
