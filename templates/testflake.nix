{
  # Rename to flake.nix
  description = "Flake for quickly testing configurations using 'nix flake check -L'";
  # CHECK WHETHER YOU'RE ON NIXPKGS-unstable or NIXOS-unstable
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

  outputs = {
    self,
    nixpkgs,
    ...
  }: let
    testModule = {
      pkgs,
      self,
      ...
    }: let
      inherit (pkgs) lib;
      nixos-lib = import (pkgs.path + "/nixos/lib") {};
    in
      (nixos-lib.runTest {
        hostPkgs = pkgs;
        defaults.documentation.enable = lib.mkDefault false;
        node.specialArgs = {inherit self;};
        imports = [
          {
            name = "test";
            nodes.test = {
              self,
              pkgs,
              ...
            }: {
              ###############
              #SYSTEM#CONFIG#
              ###############
            };
            testScript = ''
              output = test.succeed("echo test");
              assert "test" in output, f"'{output}' does not contain 'test'"
            '';
          }
        ];
      }).config.result;
  in {
    nixosModules.etcTest = testModule;
    checks = nixpkgs.lib.genAttrs ["x86_64-linux"] (system: {
      testModule = testModule {
        self = self;
        pkgs = nixpkgs.legacyPackages.${system};
      };
    });
  };
}
