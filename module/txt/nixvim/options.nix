{ config, lib, user, ... }:

lib.mkSubmodule "nixvim" config {
    programs.nixvim.opts = {
        backup = false;
        clipboard = "unnamedplus";
        cmdheight = 2;
        completeopt = [
            "menuone"
            "noselect"
        ];
        conceallevel = 0;
        cursorline = true;
        expandtab = true;
        fileencoding = "utf-8";
        hlsearch = false;
        history = 1;
        incsearch = true;
        ignorecase = true;
        linebreak = true;
        mouse = "a";
        number = true;
        numberwidth = 4;
        pumheight = 10;
        relativenumber = true;
        scrolloff = 8;
        shiftwidth = 4;
        showmode = false;
        showtabline = 0;
        sidescrolloff = 8;
        signcolumn = "auto";
        smartcase = true;
        spell = true;
        spelllang="en";
        splitbelow = true;
        splitright = true;
        swapfile = false;
        tabstop = 4;
        termguicolors = true;
        timeoutlen = 150;
        undofile = true;
        undodir = "/home/${user}/.cache/nvim/undo";
        updatetime = 300;
        whichwrap = "bs<>[]hl";
        wrap = true;
        writebackup = true;
        list = true;
        listchars = {
            tab = "╰╶";
            leadmultispace = "╰╶╶╶";
            trail = "␣";
        };
        fillchars = {
            eob = " ";
        };
        laststatus = 0;
        pumblend = 5;
        tabline = "";
    };
}
