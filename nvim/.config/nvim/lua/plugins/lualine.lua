require("lualine").setup({
	options = {
		icons_enabled = true,
		theme = "auto",
		component_separators = { left = "|", right = "|" },
		section_separators = { left = "", right = "" },
	},
	tabline = { lualine_a = { "buffers" } },
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch", "diff", "diagnostics" },
		lualine_c = { "filename" },
		lualine_x = { "encoding", "filetype" },
		lualine_y = { {
			name = "datetime",
			extra_config = { style = "Time %H:%M" },
		} },
		lualine_z = { "searchcount" },
	},
	inactive_sections = {
		lualine_a = { "mode" },
		lualine_c = { "filename" },
	},
})
