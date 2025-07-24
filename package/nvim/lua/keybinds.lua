require("which-key").setup()
require("which-key").add({
    { 
        mode = { "n", "i" },
	{ "<C-BS>", "<C-\\><C-o>db", { noremap = true, desc = "Delete word", silent = true}}
    }
})
