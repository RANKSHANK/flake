{
  rustPlatform,
  fromNpins,
  ...
}: let
  src = fromNpins."blink.cmp";
in
  rustPlatform.buildRustPackage
  {
    pname = "blink.cmp";
    version = "git";

    inherit src;

    cargoHash = "sha256-pWBOPMUy/gXeujaowlp2I6kqD+Q95h+f9mXl231DN88=";

    # Cheers Gerg-L

    # Tries to call git
    preBuild = ''
      rm build.rs
    '';

    postInstall = ''
      cp -r {lua,plugin} "$out"
      mkdir -p "$out/doc"
      cp 'doc/'*'.txt' "$out/doc/"
      mkdir -p "$out/target"
      mv "$out/lib" "$out/target/release"
    '';

    # Uses rust nightly
    env.RUSTC_BOOTSTRAP = true;
    # Don't move /doc to $out/share
    forceShare = [];
  }
