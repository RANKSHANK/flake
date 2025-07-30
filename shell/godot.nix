{
  pkgs,
  lib,
  ...
}: let
  inherit (lib.attrsets) attrValues;
  inherit (lib.meta) getVersion;
in
  pkgs.mkShell.override {stdenv = pkgs.clangStdenv;} {
    buildinputs = attrValues {
      inherit (pkgs) rustc cargo rustfmt libclang godot;
      inherit (pkgs.nixgl.auto) nixGLDefault;
    };

    LIBCLANG_PATH = "${pkgs.libclang.lib}/lib";

    BINDGEN_EXTRA_CLANG_ARGS = ''
      -isystem ${pkgs.llvmPackages.libclang.lib}/lib/clang/${getVersion pkgs.clang}/include
      -isystem ${pkgs.llvmPackages.libclang.out}/lib/clang/${getVersion pkgs.clang}/include
      -isystem ${pkgs.glibc.dev}/include
    '';

    # For Rust language server and rust-analyzer
    RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";

    # Alias the godot engine to use nixGL
    shellHook = ''
      alias godot="nixGL godot -e"
    '';
  }
