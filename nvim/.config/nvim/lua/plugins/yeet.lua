require("yeet").setup({
	clear_before_yeet = false,
	interrupt_before_yeet = true,
})

local keys = {
	{
		-- Pop command cache open
		"<leader><BS>",
		function()
			require("yeet").list_cmd()
		end,
		{ desc = "Open yeet command cache" },
	},
	{
		-- Open target selection
		"<leader>yt",
		function()
			require("yeet").select_target()
		end,
		{ desc = "Open yeet target select" },
	},
	{
		-- Douple tap \ to yeet at something
		"\\\\",
		function()
			require("yeet").execute()
		end,
		{ desc = "Yeet" },
	},
	{
		-- Toggle autocommand for yeeting after write
		"<leader>yo",
		function()
			require("yeet").toggle_post_write()
			if vim.g.yeetaucmd then
				vim.g.yeetaucmd = false
				vim.notify("disabled yeet aucmd")
			else
				vim.g.yeetaucmd = true
				vim.notify("enabled yeet aucmd")
			end
		end,
		{ desc = "Toggle post write yeet aucmd" },
	},
	{
		-- Run command without clearing terminal, send C-c
		"<leader>\\",
		function()
			require("yeet").execute(nil, { clear_before_yeet = true, interrupt_before_yeet = true })
		end,
		{ desc = "Yeet last yoted command" },
	},
	{
		-- Yeet visual selection. Useful sending core to a repl or running multiple commands.
		"<leader>yv",
		function()
			require("yeet").execute_selection({ clear_before_yeet = false })
		end,
		{ desc = "Yeet selected text" },
		mode = { "n", "v" },
	},
	{
		-- yeet go vet
		"<leader>yg",
		function()
			require("yeet").execute("go vet ./... && golangci-lint run ./...", { clear_before_yeet = true })
		end,
		{ desc = "Yeet go vet + golangci-lint" },
	},
}

for _, elem in ipairs(keys) do
	local mode = "n"
	if elem[4] ~= nil then
		mode = elem[4]
	end

	vim.keymap.set(mode, elem[1], elem[2], elem[3])
end
