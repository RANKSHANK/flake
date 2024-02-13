pkgs: {

  lazy-nix-helper = pkgs.vimUtils.buildVimPlugin {
      name = "lazy-nix-helper.nvim";
      src = pkgs.fetchFromGitHub {
          owner = "b-src";
          repo = "lazy-nix-helper.nvim";
          rev = "63b20ed";
          sha256 = "sha256-TBDZGj0NXkWvJZJ5ngEqbhovf6RPm9N+Rmphz92CS3Q=";
      };
  };

  inherit (pkgs.vimPlugins.nvim-treesitter) withAllGrammars;
  inherit
      (pkgs.vimPlugins)
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
      kanagawa-nvim
      vim-illuminate
      leap-nvim
      lsp_lines-nvim
      lualine-nvim
      nvim-navic
      neodev-nvim
      noice-nvim
      no-neck-pain-nvim
      nui-nvim
      nvim-base16
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
