{
  inputs,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.attrsets) attrValues;
  inherit (lib.fileset) toSource unions;
  inherit (inputs.mnw.lib) npinsToPlugins wrap;

  injectBaseColors = let
    inherit (inputs.stylix.inputs) base16;
    mk-scheme-attrs = (pkgs.callPackage base16.lib {}).mkSchemeAttrs;

    colors = (mk-scheme-attrs (pkgs.callPackage ../../module/theme/scheme.nix {})).withHashtag;
  in ''
    BASE00 = "${colors.base00}"
    BASE01 = "${colors.base01}"
    BASE02 = "${colors.base02}"
    BASE03 = "${colors.base03}"
    BASE04 = "${colors.base04}"
    BASE05 = "${colors.base05}"
    BASE06 = "${colors.base06}"
    BASE07 = "${colors.base07}"
    BASE08 = "${colors.base08}"
    BASE09 = "${colors.base09}"
    BASE0A = "${colors.base0A}"
    BASE0B = "${colors.base0B}"
    BASE0C = "${colors.base0C}"
    BASE0D = "${colors.base0D}"
    BASE0E = "${colors.base0E}"
    BASE0F = "${colors.base0F}"
  '';
in wrap pkgs {
  inherit (inputs.neovim-nightly.packages.${pkgs.system}) neovim;

  appName = "nvim";

  initLua = ''
    ${injectBaseColors}
    require("options")
    require("lz.n")
    require("theme")
    require("lz.n").register_handler(require("handlers.which-key"))
    require("keybinds")
    require("lz.n").load("plugins")
  '';

  plugins = {
    start = npinsToPlugins pkgs ./startup.json;

    opt =
      attrValues {
        inherit (inputs.self.packages.${pkgs.system}) blink-cmp;
        inherit (pkgs.vimPlugins.nvim-treesitter) withAllGrammars;
      }
      ++ npinsToPlugins pkgs ./lazy.json;

    dev.nvim = {
      pure = toSource {
        root = ./.;
        fileset = unions [./lua];
      };
      impure = "/home/rankshank/projects/flake/package/nvim";
    };
  };

  extraBinPath = attrValues {
    inherit
      (pkgs)
      bash-language-server
      deadnix
      fzf
      imagemagick
      lua-language-server
      marksman
      nil
      ripgrep
      statix
      vscode-langservers-extracted
      ;
  };
}
