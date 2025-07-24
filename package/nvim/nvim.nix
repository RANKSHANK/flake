{
  inputs,
  pkgs,
  lib,
  ...
}: let
  inherit (builtins) attrValues;
  inherit (lib) fileset;
  inherit (inputs) mnw;
  inherit (mnw.lib) npinsToPlugins;

  theme = let
    inherit (inputs.stylix.inputs) base16;
    mk-scheme-attrs = (pkgs.callPackage base16.lib {}).mkSchemeAttrs;

    colors = (mk-scheme-attrs (pkgs.callPackage ../../module/theme/scheme.nix {inherit pkgs;})).withHashtag;
  in ''
    require("base16-colorscheme").setup({  base00 = "${colors.base00}",
      base01 = "${colors.base01}",
      base02 = "${colors.base02}",
      base03 = "${colors.base03}",
      base04 = "${colors.base04}",
      base05 = "${colors.base05}",
      base06 = "${colors.base06}",
      base07 = "${colors.base07}",
      base08 = "${colors.base08}",
      base09 = "${colors.base09}",
      base0A = "${colors.base0A}",
      base0B = "${colors.base0B}",
      base0C = "${colors.base0C}",
      base0D = "${colors.base0D}",
      base0E = "${colors.base0E}",
      base0F = "${colors.base0F}",
    })
    vim.cmd([[
       hi link LspUnderlineError DiagnosticError
       hi link DiagnosticUnderlineError DiagnosticError
       hi link LspDiagnosticUnderlineError DiagnosticError
       hi link LspDiagnosticsUnderlineError DiagnosticError
       hi link LspUnderlineWarn DiagnosticWarn
       hi link LspDiagnosticUnderlineWarn DiagnosticWarn
       hi link LspUnderlineInformation DiagnosticInfo
       hi link LspDiagnosticUnderlineInformation DiagnosticInfo
       hi link LspUnderlineHint DiagnosticHint
       hi link LspDiagnosticUnderlineHint DiagnosticHint
       hi link Whichkey FloatBoarder
       hi link WhichkeyBorder FloatBoarder
       hi link TelescopeBorder FloatBorder
       hi link TelescopeTitle FloatBorder
       hi link TelescopePreviewBorder FloatBorder
       hi link TelescopeResultsBorder FloatBorder
       hi TelescopePromptBorder guifg=${colors.base05}
       hi TelescopePromptBorder guibg=${colors.base00}
       hi TelescopeBorder guifg=${colors.base05}
       hi TelescopeBorder guibg=${colors.base00}
    ]])
  '';
in (mnw.lib.wrap pkgs {
  neovim = inputs.neovim-nightly.packages.${pkgs.system}.neovim;

  appName = "nvim";
  initLua =
    ''
      require("options")
      require("lz.n")
      require("lz.n").register_handler(require("handlers.which-key"))
      require("lz.n").load("theme.lua")
    ''
    + theme
    + ''
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
      pure = fileset.toSource {
        root = ./.;
        fileset = fileset.unions [./lua];
      };
      impure = "/home/rankshank/projects/flake/package/nvim";
    };
  };

  extraBinPath = attrValues {
    inherit
      (pkgs)
      deadnix
      statix
      nil
      lua-language-server
      stylua
      vscode-langservers-extracted
      ripgrep
      fzf
      ;
  };
})
