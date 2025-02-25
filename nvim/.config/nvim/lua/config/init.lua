require("config.options")
require("config.keymaps")
require("config.languages")
require("plugins")

local colorschemeName = nixCats("colorscheme")
if not require("nixCatsUtils").isNixCats then
	colorschemeName = "kanagawa"
end
vim.cmd.colorscheme(colorschemeName)
