local M = {}

function M.opts()
	return {
		filetypes = { "go", "gomod", "gowork" },
		settings = {
			gopls = {
				staticcheck = true,
				hints = {
					assignVariableTypes = true,
					compositeLiteralFields = true,
					compositeLiteralTypes = true,
					constantValues = true,
					functionTypeParameters = true,
					parameterNames = true,
					rangeVariableTypes = true,
				},
			},
		},
	}
end

function M.on_attach(args, client)
	if client:supports_method("textDocument/inlayHint", args.buf) then
		vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
	end
end

return M
