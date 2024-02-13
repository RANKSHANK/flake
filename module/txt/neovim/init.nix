lib: config: plugins: let
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
  inherit (config.lib.stylix.colors.withHashtag)
    base00
    base01
    base02
    base03
    base04
    base05
    base06
    base07
    base08
    base09
    base0A
    base0B
    base0C
    base0D
    base0E
    base0F;
in ''
local plugins = {
    ${pluginLoadStr (builtins.attrValues plugins)}
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
        "RRethy/base16-nvim",
        dir = require("lazy-nix-helper").get_plugin_path("base16"),
        lazy = false,
        config = function() require("base16-colorscheme").setup({
            base00 = "${base00}",
            base01 = "${base01}",
            base02 = "${base02}",
            base03 = "${base03}",
            base04 = "${base04}",
            base05 = "${base05}",
            base06 = "${base06}",
            base07 = "${base07}",
            base08 = "${base08}",
            base09 = "${base09}",
            base0A = "${base0A}",
            base0B = "${base0B}",
            base0C = "${base0C}",
            base0D = "${base0D}",
            base0E = "${base0E}",
            base0F = "${base0F}",
        }) end,
    },
})
''
