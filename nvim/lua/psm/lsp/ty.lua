local M = {}

function M.opts()
	return {
		root_markers = {
			"ty.toml",
			"pyproject.toml",
			"uv.lock",
			"setup.py",
			"setup.cfg",
			"requirements.txt",
			"Pipfile",
			".git",
		},
		settings = {
			ty = {
				diagnosticMode = "workspace",
				inlayHints = {
					variableTypes = true,
					callArgumentNames = true,
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
