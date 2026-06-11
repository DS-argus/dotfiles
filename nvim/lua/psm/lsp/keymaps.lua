local M = {}

function M.on_attach(args)
	local function map(mode, lhs, rhs, desc)
		vim.keymap.set(mode, lhs, rhs, {
			buffer = args.buf,
			silent = true,
			desc = desc,
		})
	end

	map("n", "gd", vim.lsp.buf.definition, "정의로 이동")
	map("n", "gvd", function()
		vim.cmd.vsplit()
		vim.lsp.buf.definition()
	end, "정의로 이동 (수직 분할)")
	map("n", "ghd", function()
		vim.cmd.split()
		vim.lsp.buf.definition()
	end, "정의로 이동 (가로 분할)")
	map("n", "gD", vim.lsp.buf.declaration, "선언으로 이동")
	map("n", "gR", vim.lsp.buf.references, "참조 보기")
	map("n", "K", vim.lsp.buf.hover, "호버 문서 보기")
	map("n", "<leader>rn", vim.lsp.buf.rename, "심볼 이름 바꾸기")
	map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "코드 액션")
	map("n", "<leader>ld", vim.diagnostic.open_float, "줄 진단 보기")
	map("n", "<leader>ls", vim.lsp.buf.document_symbol, "문서 심볼 보기")
end

return M
