require("conform").setup({
	formatters_by_ft = {
		rust = { "rustfmt" },
		lua = { "stylua" },
		nix = { "nixpkgs_fmt" },
		typescriptreact = { "prettier" },
		typescript = { "prettier" },
		javacriptreact = { "prettier" },
		javascript = { "prettier" },
		go = { "gofmt", "goimports" },
		cpp = { "clang-format" },
		erlang = { "erlfmt" },
	},
	format_on_save = function(bufnr)
		if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
			return
		end
		local cwd = vim.fn.getcwd()
		if string.find(cwd, "cashout") then
			return
		end
		return { timeout = 500, lsp_fallback = true }
	end,
})

vim.api.nvim_create_user_command("FormatToggle", function(args)
	local toggleOff = false
	if vim.g.disable_autoformat then
		vim.g.disable_autoformat = false
		toggleOff = true
	end
	if vim.b.disable_autoformat then
		vim.b.disable_autoformat = false
		toggleOff = true
	end

	if not toggleOff then
		if args.bang then
			vim.b.disable_autoformat = true
		else
			vim.g.disable_autoformat = true
		end
	end
end, {
	desc = "Toggle autoformatting on save",
	bang = true,
})

-- Create a command `:Format`
vim.api.nvim_create_user_command("Format", function(args)
	require("conform").format({ bufnr = args.buf })
end, { desc = "Format current buffer with conform" })

-- Format keymap
vim.keymap.set("n", "<leader>fm", "<cmd>Format<cr>", { desc = "Run formatter" })
