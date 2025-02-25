-- load the plugins via pckr when not on nix
-- YOU are in charge of putting the plugin
-- urls and build steps in there, which will only be used when not on nix,
-- and you should keep any setup functions
-- OUT of that file, as they are ONLY loaded when this
-- configuration is NOT loaded via nix.
require("nixCatsUtils.catPacker").setup({
	--[[ ------------------------------------------ ]]
	--[[ ### DONT USE CONFIG VARIABLE ###           ]]
	--[[ unless you are ok with that instruction    ]]
	--[[ not being ran when used via nix,           ]]
	--[[ pckr will not be ran when using nix        ]]
	--[[                                            ]]
	--[[ The way to think of this is, its very      ]]
	--[[ similar to the main nix file for nixCats   ]]
	--[[ It has an opt for optional plugins, and    ]]
	--[[ it can be used to download your plugins.   ]]
	--[[ but, we dont want to handle anything about ]]
	--[[ loading those plugins here, so that we can ]]
	--[[ use the same loading code that we use for  ]]
	--[[ our normal nix-loaded config               ]]
	--[[ we will do all our loading and configuring ]]
	--[[ elsewhere in our configuration, so that    ]]
	--[[ we dont have to write it twice.            ]]
	--[[ ------------------------------------------ ]]
	{ "savq/melange-nvim" },
	{ "yorumicolors/yorumi.nvim" },
	{ "f4z3r/gruvbox-material.nvim" },
	{ "rebelot/kanagawa.nvim" },
	{ "nvim-tree/nvim-web-devicons" },
	{ "nvim-lua/plenary.nvim" },
	{ "farmergreg/vim-lastplace" },

	{
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
		requires = {
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
	},

	{
		"neovim/nvim-lspconfig",
		requires = {
			{ "williamboman/mason.nvim" },
			{ "williamboman/mason-lspconfig.nvim" },
			{ "j-hui/fidget.nvim" },
			{ "folke/neodev.nvim" },
		},
	},

	{
		"hrsh7th/nvim-cmp",
		requires = {
			{ "L3MON4D3/LuaSnip" },
			{ "saadparwaiz1/cmp_luasnip" },
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "hrsh7th/cmp-nvim-lua" },
			{ "hrsh7th/cmp-path" },
			{ "hrsh7th/cmp-buffer" },
		},
	},
	{ "stevearc/conform.nvim" },

	{
		"mfussenegger/nvim-dap",
		requires = {
			{ "nvim-neotest/nvim-nio" },
			{ "rcarriga/nvim-dap-ui" },
			{ "theHamsta/nvim-dap-virtual-text" },
			{ "jay-babu/mason-nvim-dap.nvim" },
			{ "leoluz/nvim-dap-go" },
			{ "weissle/persistent-breakpoints.nvim" },
		},
	},

	{ "stevearc/oil.nvim" },
	{ "mbbill/undotree" },
	{ "folke/which-key.nvim" },
	{ "lewis6991/gitsigns.nvim" },
	{ "nvim-lualine/lualine.nvim" },
	{ "lukas-reineke/indent-blankline.nvim" },
	{ "numToStr/Comment.nvim" },
	{ "kylechui/nvim-surround" },
	{ "max397574/better-escape.nvim" },
	{ "akinsho/toggleterm.nvim" },
	{ "justinmk/vim-sneak" },
	{ "ibhagwan/fzf-lua" },
	{ "sindrets/diffview.nvim" },
	{ "tpop/vim-fugitive" },
	{ "samharju/yeet.nvim" },
	{ "abecodes/tabout.nvim" },
	{
		"folke/noice.nvim",
		requires = {
			"MunifTannjim/nui.nvim",
		},
	},

	{
		"nvim-neotest/neotest",
		requires = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"fredrikaverpil/neotest-golang",
		},
	},

	-- all the rest of the setup will be done using the normal setup functions later,
	-- thus working regardless of what method loads the plugins.
	-- only stuff pertaining to downloading should be added to pckr.
})
-- OK, again, that isnt needed if you load this setup via nix, but it is an option.
