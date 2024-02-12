{
  user,
  pkgs,
  inputs,
  config,
  lib,
  ...
}: let
  plugins = {
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

    lazy-nix-helper = pkgs.vimUtils.buildVimPlugin {
      name = "lazy-nix-helper.nvim";
      src = pkgs.fetchFromGitHub {
        owner = "b-src";
        repo = "lazy-nix-helper.nvim";
        rev = "63b20ed";
        sha256 = "sha256-TBDZGj0NXkWvJZJ5ngEqbhovf6RPm9N+Rmphz92CS3Q=";
      };
    };
  };
  pluginLoadStr = plugins:
    builtins.concatStringsSep ",\n" (map
      (
        plugin: "\t[ \"${lib.pipe plugin [
          (lib.getName)
          (lib.removePrefix "vimplugin-")
          (lib.removePrefix "lua5.1-")
        ]}\" ] = \"${plugin.outPath}\""
      )
      plugins);
in lib.mkModule "neovim" [ "shell" ] config {
    nixpkgs.overlays = [
      (
        final: prev: {
          neovim = {
            buildInputs = lib.flatten [
              prev.buildInputs
              (builtins.attrValues {
                inherit (pkgs) rg fzf;
              })
            ];
          };
        }
      )
    ];

    home-manager.users.${user} = {
      xdg.configFile.nvim = {
        source = ./config;
        recursive = true;
      };

      programs.neovim = {
        plugins = builtins.attrValues plugins;
        enable = true;
        defaultEditor = true;
        package = inputs.neovim-nightly.packages.${pkgs.system}.neovim;

        extraLuaConfig = ''
                   local plugins = {
                     ${pluginLoadStr config.home-manager.users.${user}.programs.neovim.plugins}
                   }
                   local lazy_nix_helper_path = "${plugins.lazy-nix-helper}"
               if not vim.loop.fs_stat(lazy_nix_helper_path) then
                   lazy_nix_helper_path = vim.fn.stdpath("data") .. "/lazy_nix_helper/lazy_nix_helper.nvim"
                   if not vim.loop.fs_stat(lazy_nix_helper_path) then
                     vim.fn.system({
                       "git",
                       "clone",
                       "--filter=blob:none",
                       "https://github.com/b-src/lazy_nix_helper.nvim.git",
                       lazy_nix_helper_path,
                     })
                   end
                 end

               -- add the Lazy Nix Helper plugin to the vim runtime
               vim.opt.rtp:prepend(lazy_nix_helper_path)

               -- call the Lazy Nix Helper setup function
               local non_nix_lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
               local lazy_nix_helper_opts = { lazypath = non_nix_lazypath, input_plugin_table = plugins }
               require("lazy-nix-helper").setup(lazy_nix_helper_opts)

               -- get the lazypath from Lazy Nix Helper
               local lazypath = require("lazy-nix-helper").lazypath()
               if not vim.loop.fs_stat(lazypath) then
                 vim.fn.system({
                   "git",
                   "clone",
                   "--filter=blob:none",
                   "https://github.com/folke/lazy.nvim.git",
                   "--branch=stable", -- latest stable release
                   lazypath,
                 })
               end
               vim.opt.rtp:prepend(lazypath)

                   local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
                   vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

                   vim.g.mapleader = " "
                   vim.g.maplocalleader = " "

                   require("lazy").setup({
                   {
                     priority = 0,
                     import = "config",
                   },
                   {
                     priority = 1,
                     import = "plugins",
                   },
          {
          	priority = 2,
          	"Stylix/stylix",
          	dir = require("lazy-nix-helper").get_plugin_path("stylix"),
          	-- "rebelot/kanagawa.nvim",
          	-- dir = require("lazy-nix-helper").get_plugin_path("kanagawa-nvim"),
          	lazy = false,
          	--opts = {
          	--	dimInactive = true,
          	--},
          },
                   })
        '';
      };
  };
}
