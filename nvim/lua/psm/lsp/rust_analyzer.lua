local M = {}

function M.opts()
	return {}
end

function M.on_attach(args, client)
	if client:supports_method("textDocument/inlayHint", args.buf) then
		vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
	end
end

return M
