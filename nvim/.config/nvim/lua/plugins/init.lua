local plugins = {
	"Comment",
	"ibl",
	"which-key",
	"nvim-surround",
	"better_escape",
}

for _, plugin in ipairs(plugins) do
	require(plugin).setup()
end

-- undo tree
vim.keymap.set("n", "<leader>fu", "<cmd>UndotreeToggle<cr>", { desc = "Find Undo" })

-- oil
require("oil").setup({
	skip_confirm_for_simple_edits = true,
})
vim.keymap.set("n", "<leader>fo", "<cmd>Oil --float<cr>", { desc = "Folder Open" })

-- toggle term
require("toggleterm").setup({
	open_mapping = [[<c-\>]], -- unused mapping
	shade_terminals = false,
})
vim.keymap.set({ "n" }, "<leader>tt", "<cmd>ToggleTerm<cr>", { nowait = true, desc = "Toggle last terminal" })
vim.keymap.set({ "t" }, "<esc>", "<c-\\><c-n>", { desc = "Escape terminal mode" })

vim.keymap.set(
	{ "n" },
	"<leader>tv",
	"<cmd>101ToggleTerm direction=vertical size=80<cr>",
	{ nowait = true, desc = "Toggle vertical terminal" }
)

-- vim sneak
vim.keymap.set("n", "s", "<Plug>Sneak_s", { desc = "sneak forward" })
vim.keymap.set("n", "S", "<Plug>Sneak_S", { desc = "sneak backward" })

vim.keymap.set("n", "<leader>gg", "<cmd>Git<cr>", { desc = "Open git" })

require("plugins.cmp")
require("plugins.conform")
require("plugins.dap")
require("plugins.fzf")
require("plugins.gitsigns")
require("plugins.lsps")
require("plugins.lualine")
require("plugins.neotest")
require("plugins.noice")
require("plugins.tabout")
require("plugins.treesitter")
require("plugins.yeet")
