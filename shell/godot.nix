{pkgs ? import <nixpkgs> {}, ...}:
pkgs.mkShell.override {stdenv = pkgs.clangStdenv;} {
  buildinputs = builtins.attrValues {
    inherit (pkgs) rustc cargo rustfmt libclang godot;
    inherit (pkgs.nixgl.auto) nixGLDefault;
  };

  LIBCLANG_PATH = "${pkgs.libclang.lib}/lib";

  BINDGEN_EXTRA_CLANG_ARGS = with pkgs; ''
    -isystem ${llvmPackages.libclang.lib}/lib/clang/${lib.getVersion clang}/include
    -isystem ${llvmPackages.libclang.out}/lib/clang/${lib.getVersion clang}/include
    -isystem ${glibc.dev}/include
  '';

  # For Rust language server and rust-analyzer
  RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";

  # Alias the godot engine to use nixGL
  shellHook = ''
    alias godot="nixGL godot -e"
  '';
}
