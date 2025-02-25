-- Keymaps for better default experience
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
vim.keymap.set({ "n", "v", "i", "t" }, "<F1>", "<Nop>", { silent = true })
vim.keymap.set("n", "<c-h>", "<cmd>nohl<cr>", { desc = "hide highlights" })

-- center when searching or doing big jumps
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll Down" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll Up" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Next Search Result" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous Search Result" })

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Buffer movement
vim.keymap.set("n", "<leader>j", "<cmd>bprev<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "<leader>k", "<cmd>bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>b", "<cmd>b#<CR>", { desc = "Last buffer" })
vim.keymap.set("n", "<leader>x", "<cmd>bdelete<CR>", { desc = "Delete buffer" })
vim.keymap.set("n", "<c-w>b", "<cmd>w<bar>%db<bar>e#<bar>bd#<CR>", { desc = "Delete all buffers apart from current" })

-- better pasting
vim.keymap.set("x", "p", "pgvy", { silent = true })
vim.keymap.set("x", "P", "Pgvy", { silent = true })

-- disable annoying keybind
vim.keymap.set("n", "q:", "<nop>", { silent = true })

vim.api.nvim_create_autocmd({ "FileType", "BufReadPost" }, {
	desc = "Add keymap for ticket based on git branch",
	pattern = "gitcommit",
	group = vim.api.nvim_create_augroup("gitcommit_cmds", {}),
	callback = function()
		vim.keymap.set("n", "<leader>gt", function()
			local branches = vim.fn.system({ "git", "branch" })
			local currentBranch = vim.fn.system({ "sed", "/^[^\\*]/d" }, branches)
			local ticket = vim.fn.system({ "sed", "-r", "s/^\\* [^\\/]*[\\/ ](\\w+-\\w+)-?.*/\\1/" }, currentBranch)
			ticket = ticket:gsub("[\n\r]", "")

			local pos = vim.api.nvim_win_get_cursor(0)

			local line = vim.api.nvim_get_current_line()
			local newLine = line:sub(1, pos[2] + 1) .. ticket .. line:sub(pos[2] + 2):gsub("^ (.*)", "%1")
			newLine = newLine:gsub("[\n\r]", "")

			vim.api.nvim_set_current_line(newLine)

			vim.api.nvim_win_set_cursor(0, { pos[1], (string.len(ticket) + pos[2]) })
			vim.cmd("startinsert")
			local keys = vim.api.nvim_replace_termcodes("<right> ", true, false, true)
			vim.api.nvim_feedkeys(keys, "i", true)
		end, { desc = "Insert current ticket number into buffer" })
	end,
})
