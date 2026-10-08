local M = {}

function M.opts()
	return {
		settings = {
			["rust-analyzer"] = {
				-- 저장 시 cargo check 대신 cargo clippy로 rustc + clippy lint를 함께 받는다.
				check = { command = "clippy" },
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
