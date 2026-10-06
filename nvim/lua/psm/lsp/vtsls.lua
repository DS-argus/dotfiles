local M = {}

local inlay_hints = {
	parameterNames = { enabled = "literals" },
	parameterTypes = { enabled = true },
	variableTypes = { enabled = true },
	propertyDeclarationTypes = { enabled = true },
	functionLikeReturnTypes = { enabled = true },
	enumMemberValues = { enabled = true },
}

function M.opts()
	return {
		settings = {
			typescript = { inlayHints = inlay_hints },
			javascript = { inlayHints = inlay_hints },
		},
	}
end

function M.on_attach(args, client)
	if client:supports_method("textDocument/inlayHint", args.buf) then
		vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
	end
end

return M
