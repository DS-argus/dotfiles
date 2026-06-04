local M = {}

function M.opts()
	return {
		filetypes = { "go", "gomod", "gowork" },
		settings = {
			gopls = {
				staticcheck = true,
			},
		},
	}
end

return M
