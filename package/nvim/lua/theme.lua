require("base16-colorscheme").setup({
  base00 = BASE00,
  base01 = BASE01,
  base02 = BASE02,
  base03 = BASE03,
  base04 = BASE04,
  base05 = BASE05,
  base06 = BASE06,
  base07 = BASE07,
  base08 = BASE08,
  base09 = BASE09,
  base0A = BASE0A,
  base0B = BASE0B,
  base0C = BASE0C,
  base0D = BASE0D,
  base0E = BASE0E,
  base0F = BASE0F,
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
   hi link TelescopeTitle PomptBorder
   hi link TelescopePreviewBorder FloatBorder
   hi link TelescopeResultsBorder FloatBorder
   hi TelescopePromptTitle guifg=base05
   hi TelescopePromptTitle guibg=base00
   hi TelescopeResultsTitle guifg=base05
   hi TelescopeResultsTitle guibg=base00
   hi TelescopeNormal guifg=base05
   hi TelescopeNormal guibg=base00
   hi TelescopePromptBorder guifg=base05
   hi TelescopePromptBorder guibg=base00
   hi TelescopePromptBorder guifg=base05
   hi TelescopePromptBorder guibg=base00
   hi TelescopeBorder guifg=base05
   hi TelescopeBorder guibg=base00
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
