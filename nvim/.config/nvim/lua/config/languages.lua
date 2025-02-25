local group = vim.api.nvim_create_augroup("sw_aucmds", {})

local function set_ts_sw(size)
	vim.bo[0].tabstop = size
	vim.bo[0].shiftwidth = size
end

local two = { "nix", "haskell", "rust", "erlang", "elixir", "c" }
local four = { "lua", "cabal" }

for _, pat in ipairs(two) do
	vim.api.nvim_create_autocmd({ "FileType", "BufReadPost" }, {
		desc = "Set tw and sw",
		pattern = pat,
		group = group,
		callback = function()
			set_ts_sw(2)
		end,
	})
end

for _, pat in ipairs(four) do
	vim.api.nvim_create_autocmd({ "FileType", "BufReadPost" }, {
		desc = "Set tw and sw",
		pattern = pat,
		group = group,
		callback = function()
			set_ts_sw(4)
		end,
	})
end
