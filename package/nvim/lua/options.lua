vim.g.mapleader = " "
for k, v in pairs({
    backup = false,
    clipboard = "unnamedplus",
    cmdheight = 1,
    completeopt = {
        "menuone",
        "noselect"
    },
    conceallevel = 0,
    cursorline = true,
    expandtab = true,
    fileencoding = "utf-8",
    hlsearch = false,
    history = 1,
    incsearch = true,
    ignorecase = true,
    laststatus = 0,
    linebreak = true,
    list = true,
    listchars = {
        trail = "␣",
    },
    mouse = "a",
    number = true,
    -- numberwidth = 4,
    pumheight = 10,
    pumblend = 5,
    relativenumber = true,
    scrolloff = 8,
    shiftwidth = 4,
    showmode = false,
    showtabline = 0,
    sidescrolloff = 10,
    signcolumn = "number",
    smartcase = true,
    spell = true,
    spelllang = en,
    swapfile = false,
    tabline = "",
    tabstop = 4,
    termguicolors = true,
    timeoutlen = 150,
    undofile = true,
    undodir = os.getenv("HOME") .. "/.cache/nvim/undo",
    updatetime = 300,
    whichwrap = "bs<>[]hl",
    wrap = true,
    writebackup = false,
}) do
    vim.opt[k] = v
end

vim.g.icons = {
    diagnostics = {
        error = "",
        warn = "",
        info = "",
        hint = "󰌶",
    },
    file_status = {
        modified = "󰳻",
        readonly = "",
        unnamed = "󱀶",
        directory = "",
    },
    git = {
        added = "",
        modified = "󰦓",
        removed = "",
    },
}
