local M = {}

function M.hasModernGit()
	local gitVersion = vim.fn.system("git --version")
	for n in string.gmatch(gitVersion, "%d") do
		return tonumber(n) >= 2
	end
end

return M
