-- Better searching
vim.o.hlsearch = true
vim.o.smartcase = true
vim.o.ignorecase = true
vim.o.gdefault = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.cursorline = true
vim.opt.colorcolumn = "100"

-- Make line numbers default
vim.wo.number = true
vim.wo.relativenumber = true

-- Enable mouse mode
vim.o.mouse = "a"

-- Indent
-- stops line wrapping from being confusing
vim.o.breakindent = true
vim.o.expandtab = true
vim.o.joinspaces = false
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4

-- Save undo history
vim.o.undofile = true

-- Keep signcolumn on by default
vim.wo.signcolumn = "yes"

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect,popup"

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- do not sync OS clipboard
vim.o.clipboard = ""

-- use this font
vim.o.guifont = "JetBrains Mono:h16"

-- don't show mode in command bar
vim.o.showmode = false

-- split in sane directions
vim.o.splitbelow = true
vim.o.splitright = true

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = "*",
})

vim.o.spell = true
vim.o.spelllang = "en_gb"

vim.api.nvim_create_autocmd("TermOpen", {
	desc = "disable spell in terminals",
	pattern = "*",
	callback = function(_)
		vim.wo[0].spell = false
	end,
})

vim.api.nvim_create_autocmd("BufRead", {
	desc = "disable spell for certain filetypes",
	pattern = { ".out", "*.log" },
	callback = function(_)
		vim.wo[0].spell = false
	end,
})
