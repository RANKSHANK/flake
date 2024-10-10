pkgs: {

  lazy-nix-helper = pkgs.vimUtils.buildVimPlugin {
      name = "lazy-nix-helper.nvim";
      src = pkgs.fetchFromGitHub {
          owner = "b-src";
          repo = "lazy-nix-helper.nvim";
          rev = "cb1c0c4";
          sha256 = "sha256-HwrO32Sj1FUWfnOZQYQ4yVgf/TQZPw0Nl+df/j0Jhbc=";
      };
  };

  inherit (pkgs.vimPlugins.nvim-treesitter) withAllGrammars;
  inherit (pkgs.vimPlugins.nvim-treesitter-parsers)
      markdown
      markdown_inline
      nix
      python;
  inherit (pkgs.vimPlugins)
      lazy-nvim
      nvim-lspconfig
      lsp-zero-nvim
      nvim-cmp
      cmp_luasnip
      cmp-vim-lsp
      cmp-treesitter
      cmp-spell
      cmp-buffer
      cmp-path
      cmp-nvim-lsp-signature-help
      luasnip
      friendly-snippets
      telescope-nvim
      telescope-undo-nvim
      telescope-fzf-native-nvim
      nvim-treesitter-textobjects
      nvim-ts-context-commentstring
      comment-nvim
      nvim-dap
      dressing-nvim
      fidget-nvim
      flit-nvim
      harpoon2
      indent-blankline-nvim
      kanagawa-nvim
      vim-illuminate
      leap-nvim
      lsp_lines-nvim
      lualine-nvim
      nvim-navic
      neodev-nvim
      noice-nvim
      no-neck-pain-nvim
      none-ls-nvim
      nui-nvim
      base16-nvim #TODO: nixpkgs#289539
      nvim-notify
      oil-nvim
      vim-repeat
      smartcolumn-nvim
      tabout-nvim
      todo-comments-nvim
      rainbow-delimiters-nvim
      treesj
      trouble-nvim
      vim-nix
      vimtex
      nvim-web-devicons
      which-key-nvim
      ;

}
