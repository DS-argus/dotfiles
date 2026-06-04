local M = {}

M.names = {
	"pyright",
	"lua_ls",
	"rust_analyzer",
	"gopls",
}

M.modules = {
	pyright = "psm.lsp.pyright",
	lua_ls = "psm.lsp.lua_ls",
	gopls = "psm.lsp.gopls",
}

function M.opts(server, capabilities)
	local opts = { capabilities = capabilities }
	local module_name = M.modules[server]

	if module_name then
		opts = vim.tbl_deep_extend("force", opts, require(module_name).opts())
	end

	return opts
end

function M.on_attach(args, client)
	local module_name = M.modules[client.name]
	if not module_name then
		return
	end

	local server = require(module_name)
	if type(server.on_attach) == "function" then
		server.on_attach(args, client)
	end
end

return M
