-- Diagnostic keymaps
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

-- quick lsp restart
vim.keymap.set("n", "<leader>ls", "<cmd>LspStart<cr>", { desc = "Start Lsp" })
vim.keymap.set("n", "<leader>ld", "<cmd>LspStop<cr>", { desc = "Stop Lsp" })

-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
	local nmap = function(keys, func, desc)
		if desc then
			desc = "LSP: " .. desc
		end

		vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
	end

	nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
	nmap("gi", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
	nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
	nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[N]ame")
	nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
	nmap("K", vim.lsp.buf.hover, "Hover docs")

	-- Lesser used LSP functionality
	nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
	nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
	nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
	nmap("<leader>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, "[W]orkspace [L]ist Folders")
end

-- servers and their configuration
local servers = {
	"gopls",
}

-- Setup neovim lua configuration
require("neodev").setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
local lspconfig = require("lspconfig")

lspconfig.gopls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

lspconfig.erlangls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})
lspconfig.clangd.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	cmd = { "clangd", "--background-index", "--clang-tidy", "--log=verbose" },
})
lspconfig.hls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

lspconfig.elixirls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	cmd = { "elixir-ls" },
})

lspconfig.lua_ls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	settings = {
		Lua = {
			runtime = { version = "LuaJIT" },
			diagnostics = { globals = { "vim" } },
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
				checkThirdParty = false,
			},
			telemetery = {
				enable = false,
			},
		},
	},
})

lspconfig.rust_analyzer.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	settings = {
		["rust-analyzer"] = {
			checkOnSave = true,
			check = {
				command = "clippy",
				extraArgs = { "--", "-W", "clippy::pedantic" },
			},
		},
	},
})
