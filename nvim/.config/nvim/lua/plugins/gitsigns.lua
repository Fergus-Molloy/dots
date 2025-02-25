if not require("utils").hasModernGit() then
	return
end

require("gitsigns").setup({
	signs = {
		add = { text = "+" },
		change = { text = "~" },
		delete = { text = "_" },
		topdelete = { text = "‾" },
		changedelete = { text = "~" },
		untracked = { text = "┆" },
	},
	signs_staged = {
		add = { text = "+" },
		change = { text = "~" },
		delete = { text = "_" },
		topdelete = { text = "‾" },
		changedelete = { text = "~" },
		untracked = { text = "┆" },
	},
	signs_staged_enable = true,
	signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
	current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
	on_attach = function(bufnr)
		local gitsigns = require("gitsigns")

		local function map(mode, l, r, opts)
			opts = opts or {}
			opts.buffer = bufnr
			vim.keymap.set(mode, l, r, opts)
		end

		-- Navigation
		map("n", "]c", function()
			if vim.wo.diff then
				vim.cmd.normal({ "]c", bang = true })
			else
				gitsigns.nav_hunk("next")
			end
		end)

		map("n", "[c", function()
			if vim.wo.diff then
				vim.cmd.normal({ "[c", bang = true })
			else
				gitsigns.nav_hunk("prev")
			end
		end)

		-- Actions
		map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "Stage hunk" })
		-- map("n", "<leader>hr", gitsigns.reset_hunk)
		map("v", "<leader>hs", function()
			gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end, { desc = "Stage hunk" })
		-- map("v", "<leader>hr", function()
		-- 	gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
		-- end)
		map("n", "<leader>hS", gitsigns.stage_buffer, { desc = "Stage whole buffer" })
		map("n", "<leader>hu", gitsigns.undo_stage_hunk, { desc = "Undo last stage hunk" })
		-- map("n", "<leader>hR", gitsigns.reset_buffer)
		map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "Preview hunk" })
		map("n", "<leader>hb", "<cmd>Git blame<cr>", { desc = "Toggle git blame" })
		map("n", "<leader>hB", function()
			gitsigns.blame_line({ full = true })
		end, { desc = "Show current line blame" })
		map("n", "<leader>hd", "<cmd>DiffviewOpen<cr>", { desc = "Open diffview" })
		-- map("n", "<leader>td", gitsigns.toggle_deleted)

		-- Text object
		map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
	end,
})
