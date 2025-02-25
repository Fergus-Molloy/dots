local fzf = require("fzf-lua")
local actions = require("fzf-lua.actions")
fzf.setup({
	actions = {
		files = {
			["enter"] = actions.file_edit, -- open multiple files in different buffers
		},
	},
})

vim.keymap.set("n", "<leader>ff", fzf.files, { desc = "Find files" })
vim.keymap.set("n", "<leader>fw", function()
	fzf.live_grep_glob({ rg_glob = true })
end, { desc = "Find word" })
vim.keymap.set("n", "<leader>fb", fzf.buffers, { desc = "Find buffer" })
vim.keymap.set("n", "<leader>o", fzf.oldfiles, { desc = "Find recently opened" })

-- lsp
vim.keymap.set("n", "<leader>gr", fzf.lsp_references, { desc = "Find references" })
vim.keymap.set("n", "<leader>ds", fzf.lsp_document_symbols, { desc = "Find document symbols" })
vim.keymap.set("n", "<leader>dd", fzf.diagnostics_document, { desc = "Find document diagnostics" })
vim.keymap.set("n", "<leader>dw", fzf.diagnostics_workspace, { desc = "Find workspace diagnostics" })

-- dap
vim.keymap.set("n", "<leader>dc", fzf.dap_configurations, { desc = "Run DAP configuration" })
vim.keymap.set("n", "<leader>dq", fzf.dap_commands, { desc = "Send DAP command" })
-- vim.keymap.set("n", "<leader>db", fzf.dap_breakpoints, { desc = "Find DAP breakpoint" })
