local pb = require("persistent-breakpoints")
pb.setup({
	load_breakpoints_event = { "BufReadPost" },
})

local go = require("dap-go")
go.setup()

local ui = require("dapui")

ui.setup()

vim.keymap.set("n", "<leader>dt", function()
	go.debug_test()
end, { desc = "debug closest tests" })
vim.keymap.set("n", "<leader>du", function()
	ui.toggle()
end, { desc = "toggle dap ui" })
vim.keymap.set("n", "<leader>db", function()
	pb.api.toggle_breakpoint()
end, { desc = "toggle dap breakpoint" })
vim.keymap.set("n", "<leader>dB", function()
	pb.api.set_conditional_breakpoint()
end, { desc = "set conditional breakpoint" })
vim.keymap.set("n", "<leader>de", function()
	ui.eval()
end, { desc = "open floating evaluation" })
vim.keymap.set("n", "<F8>", "<cmd>DapContinue<cr>", { desc = "Dap continue" })
vim.keymap.set("n", "<F7>", "<cmd>DapStepInto<cr>", { desc = "Dap step into" })
vim.keymap.set("n", "<F9>", "<cmd>DapStepOver<cr>", { desc = "Dap step over" })
