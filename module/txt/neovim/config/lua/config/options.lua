local options = {
	backup = false,
	clipboard = "unnamedplus",
	cmdheight = 2,
	completeopt = {
		"menuone",
		"noselect",
	},
	conceallevel = 0,
	cursorline = true,
	expandtab = true,
	fileencoding = "utf-8",
	hlsearch = false,
	history = 1,
	incsearch = true,
	ignorecase = true,
	linebreak = true,
	mouse = "a",
	number = true,
	numberwidth = 4,
	pumheight = 10,
	relativenumber = true,
	scrolloff = 8,
	shiftwidth = 4,
	showmode = false,
	showtabline = 0,
	sidescrolloff = 8,
	signcolumn = "number",
	smartcase = true,
    spell = true,
    spelllang="en",
	splitbelow = true,
	splitright = true,
	swapfile = false,
	tabstop = 4,
    termguicolors = true,
	timeoutlen = 150,
	undofile = true,
	undodir = os.getenv("HOME") .. "/.cache/nvim/undo",
	updatetime = 300,
	whichwrap = "bs<>[]hl",
	wrap = true,
	writebackup = true,
	-- list = true,
	-- listchars = {
	-- 	tab = "╰╶",
	-- 	leadmultispace = "╰╶╶╶",
	-- 	trail = "␣",
	-- },
    laststatus = 0,
    pumblend = 5,
    tabline = "",
}
for k, v in pairs(options) do
	vim.opt[k] = v
end

vim.opt.iskeyword:append("-")
vim.opt.formatoptions:remove({ "c", "r", "o" })

-- vim.fn.sign_define("DiagnosticSignError", { text = " ", texthl = "DiagnosticSignError" })
-- vim.fn.sign_define("DiagnosticSignWarn", { text = " ", texthl = "DiagnosticSignWarn" })
-- vim.fn.sign_define("DiagnosticSignInfo", { text = " ", texthl = "DiagnosticSignInfo" })
-- vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" })

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
    hi link TelescopePromptBorder FloatBorder
    hi link TelescopePreviewBorder FloatBorder
    hi link TelescopeResultsBorder FloatBorder
     
]])

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

return {}
