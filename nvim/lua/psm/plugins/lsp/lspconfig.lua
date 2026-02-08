return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{ "folke/neodev.nvim", opts = {} },
	},
	config = function()
		local lspconfig = require("lspconfig")
		local mason_lspconfig = require("mason-lspconfig")
		local cmp_nvim_lsp = require("cmp_nvim_lsp")

		local keymap = vim.keymap -- for conciseness

		-- (생략: LspAttach 관련 코드/키맵 설정...)

		-- used to enable autocompletion (assign to every lsp server config)
		local capabilities = cmp_nvim_lsp.default_capabilities()

		-- Change the Diagnostic symbols in the sign column (gutter)
		-- local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
		-- for type, icon in pairs(signs) do
		-- 	local hl = "DiagnosticSign" .. type
		-- 	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		-- end

		-- 최신 권장 방식
		vim.diagnostic.config({
			signs = {
			text = {
				[vim.diagnostic.severity.ERROR] = " ",
				[vim.diagnostic.severity.WARN]  = " ",
				[vim.diagnostic.severity.HINT]  = "󰠠 ",
				[vim.diagnostic.severity.INFO]  = " ",
			},
			},
		})

		-- LSP 서버 목록 (mason.lua와 동일하게 유지)
		local servers = { "pyright", "lua_ls", "rust_analyzer" } -- CSS도 제거

		-- mason-lspconfig의 setup은 mason.lua에서 처리하므로 여기서는 호출하지 않음
		-- 각 서버별 lspconfig 설정을 반복문으로 처리
		for _, server in ipairs(servers) do
			local opts = { capabilities = capabilities }
			if server == "lua_ls" then
				opts.settings = {
					Lua = {
						diagnostics = { globals = { "vim" } },
						completion = { callSnippet = "Replace" },
						workspace = {
							library = {
								[vim.fn.expand("$VIMRUNTIME/lua")] = true,
								[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
							},
							maxPreload = 100000,
							preloadFileSize = 10000,
						},
					},
				}
			end
			if server == "pyright" then
				opts.settings = {
					python = {
						analysis = {
							typeCheckingMode = "off",              -- 타입 체크 비활성화 (속도 향상)
							diagnosticMode = "openFilesOnly",       -- 열려있는 파일만 분석
							autoSearchPaths = false,                -- 자동 경로 검색 비활성화 (속도 향상)
							useLibraryCodeForTypes = false,         -- 라이브러리 코드 타입 분석 비활성화 (속도 향상)
							extraPaths = {},                        -- 필요시 패키지 경로 추가 가능
							exclude = { "venv", ".venv", "__pycache__", "*.pyc" }, -- 캐시 파일도 제외
						},
					},
				}
			end
			lspconfig[server].setup(opts)
		end
	end,
}
